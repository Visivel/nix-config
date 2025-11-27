{ inputs, pkgs, disko, agenix }:

rec {
  generateAgenixKey = pkgs.writeShellScriptBin "generate-agenix-key" ''
    sudo mkdir -p /var/lib/nixos-installer/secrets/keys
    sudo ${pkgs.age}/bin/age-keygen -o /var/lib/nixos-installer/secrets/keys/agenix.key
    sudo ${pkgs.age}/bin/age-keygen -y /var/lib/nixos-installer/secrets/keys/agenix.key
  '';

  encryptSecrets = pkgs.writeShellScriptBin "encrypt-secrets" ''
    if [ $# -ne 3 ]; then
      echo "Usage: encrypt-secrets <git-name> <git-email> <password>"
      exit 1
    fi

    GIT_NAME="$1"
    GIT_EMAIL="$2"
    USER_PASSWORD=$(${pkgs.mkpasswd}/bin/mkpasswd -m sha-512 "$3")
    INSTALLER_STATE="/var/lib/nixos-installer"

    rm -rf "$INSTALLER_STATE/*"
    mkdir -p "$INSTALLER_STATE/secrets"

    AGE_KEY="$INSTALLER_STATE/secrets/keys/agenix.key"
    AGE_PUB_KEY=$(sudo ${pkgs.age}/bin/age-keygen -y "$AGE_KEY")

    sudo tee "$INSTALLER_STATE/secrets/secrets.nix" > /dev/null <<EOF
    {
      "git-name.age".publicKeys = [ "$AGE_PUB_KEY" ];
      "git-email.age".publicKeys = [ "$AGE_PUB_KEY" ];
      "user-password.age".publicKeys = [ "$AGE_PUB_KEY" ];
    }
    EOF

    sudo mkdir -p /run/agenix
    echo "$GIT_NAME" | sudo tee /run/agenix/git-name > /dev/null
    echo "$GIT_EMAIL" | sudo tee /run/agenix/git-email > /dev/null
    echo "$USER_PASSWORD" | sudo tee /run/agenix/user-password > /dev/null

    cd "$INSTALLER_STATE/secrets"
    echo "$GIT_NAME" | sudo RULES="$INSTALLER_STATE/secrets/secrets.nix" \
      ${agenix.packages.x86_64-linux.default}/bin/agenix -e git-name.age -i "$AGE_KEY"
    echo "$GIT_EMAIL" | sudo RULES="$INSTALLER_STATE/secrets/secrets.nix" \
      ${agenix.packages.x86_64-linux.default}/bin/agenix -e git-email.age -i "$AGE_KEY"
    echo "$USER_PASSWORD" | sudo RULES="$INSTALLER_STATE/secrets/secrets.nix" \
      ${agenix.packages.x86_64-linux.default}/bin/agenix -e user-password.age -i "$AGE_KEY"

    sudo chmod 600 "$INSTALLER_STATE/secrets"/*.age
  '';

  setupDisko = pkgs.writeShellScriptBin "setup-disko" ''
    if [ $# -ne 2 ]; then
      echo "Usage: setup-disko <disk-device> <host>"
      exit 1
    fi

    DISK="$1"
    HOST="$2"
    INSTALLER_STATE="/var/lib/nixos-installer"

    sudo ${pkgs.gnused}/bin/sed "s|/dev/sdX|$DISK|g" /root/nixos-config/hosts/$HOST/system/disko.nix \
      > "$INSTALLER_STATE/disko-modified.nix"

    sudo ${disko.packages.x86_64-linux.disko}/bin/disko --mode disko "$INSTALLER_STATE/disko-modified.nix"
  '';

  copyConfiguration = pkgs.writeShellScriptBin "copy-configuration" ''
    INSTALLER_STATE="/var/lib/nixos-installer"

    sudo mkdir -p /mnt/etc/nixos
    sudo cp -r /root/nixos-config/* /mnt/etc/nixos/
    sudo rm -f /mnt/etc/nixos/secrets/secrets.nix

    sudo mkdir -p /mnt/etc/nixos/secrets/keys
    sudo cp -r "$INSTALLER_STATE/secrets/keys"/* /mnt/etc/nixos/secrets/keys/
    sudo cp "$INSTALLER_STATE/secrets"/*.age /mnt/etc/nixos/secrets/
    sudo cp "$INSTALLER_STATE/secrets/secrets.nix" /mnt/etc/nixos/secrets/
    sudo chmod 600 /mnt/etc/nixos/secrets/keys/agenix.key
    sudo chmod 600 /mnt/etc/nixos/secrets/*.age
  '';

  generateHardwareConfig = pkgs.writeShellScriptBin "generate-hardware-config" ''
    if [ $# -ne 1 ]; then
      echo "Usage: generate-hardware-config <host>"
      exit 1
    fi

    HOST="$1"

    sudo ${pkgs.nixos-install-tools}/bin/nixos-generate-config --no-filesystems --root /mnt
    sudo mv /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/$HOST/system/
    sudo rm -f /mnt/etc/nixos/configuration.nix
  '';

  setupSecureBoot = pkgs.writeShellScriptBin "setup-secure-boot" ''
    sudo rm -rf /var/lib/sbctl
    sudo mkdir -p /var/lib/sbctl

    sudo ${pkgs.sbctl}/bin/sbctl create-keys
    sudo ${pkgs.sbctl}/bin/sbctl enroll-keys --microsoft --yes-this-might-brick-my-machine

    sudo mkdir -p /mnt/var/lib/sbctl
    sudo cp -r /var/lib/sbctl/* /mnt/var/lib/sbctl/
  '';

  installSystem = pkgs.writeShellScriptBin "install-system" ''
    if [ $# -ne 1 ]; then
      echo "Usage: install-system <host>"
      exit 1
    fi

    HOST="$1"

    sudo ${pkgs.nixos-install-tools}/bin/nixos-install \
      --flake /mnt/etc/nixos#$HOST \
      --impure \
      --no-root-password
  '';

  interactiveInstaller = pkgs.writeShellScriptBin "install-os" ''
    set -euo pipefail

    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m'

    log() { echo -e "''${BLUE}[INFO]''${NC} $1"; }
    success() { echo -e "''${GREEN}[SUCCESS]''${NC} $1"; }
    warn() { echo -e "''${YELLOW}[WARN]''${NC} $1"; }
    error() { echo -e "''${RED}[ERROR]''${NC} $1"; exit 1; }

    if [ "$EUID" -ne 0 ]; then
      log "Attempting to run with sudo..."
      exec sudo "$0" "$@"
    fi

    mkdir -p /var/lib/nixos-installer/secrets/keys
    chmod 700 /var/lib/nixos-installer
    exec > >(tee -a /var/lib/nixos-installer/install.log) 2>&1

    echo "=============================================="
    echo "               NixOS Installer"
    echo "=============================================="
    echo ""

    echo "Available hosts:"
    echo "  1) desktop"
    echo "  2) laptop"
    echo ""
    read -p "Select host (1 or 2): " HOST_CHOICE

    case $HOST_CHOICE in
      1) HOST="desktop" ;;
      2) HOST="laptop" ;;
      *) error "Invalid selection" ;;
    esac

    success "Selected host: $HOST"

    [ ! -f "/root/nixos-config/hosts/$HOST/system/disko.nix" ] && \
      error "Configuration missing: /root/nixos-config/hosts/$HOST/system/disko.nix"

    success "Configuration found"

    echo ""
    log "Step 1: User Information"
    read -p "Git name: " GIT_NAME
    read -p "Git email: " GIT_EMAIL
    while true; do
      read -s -p "Password: " USER_PASSWORD
      echo ""
      read -s -p "Confirm: " USER_PASSWORD_CONFIRM
      echo ""
      [ "$USER_PASSWORD" = "$USER_PASSWORD_CONFIRM" ] && break
      warn "Passwords do not match"
    done

    echo ""
    log "Step 2: Generating encryption keys"
    ${generateAgenixKey}/bin/generate-agenix-key 2> /dev/null
    success "Keys generated"

    log "Step 3: Encrypting secrets"
    ${encryptSecrets}/bin/encrypt-secrets "$GIT_NAME" "$GIT_EMAIL" "$USER_PASSWORD"
    success "Secrets encrypted"

    echo ""
    log "Available disks:"
    ${pkgs.util-linux}/bin/lsblk -ndo NAME,SIZE,TYPE | ${pkgs.gawk}/bin/awk '$3=="disk" {print "  /dev/" $1 " - " $2}'
    echo ""
    read -p "Target disk: " DISK
    [ ! -b "$DISK" ] && error "Invalid disk: $DISK"

    echo ""
    warn "WARNING: $DISK will be completely erased!"
    read -p "Type 'YES' to continue: " CONFIRM
    [ "$CONFIRM" != "YES" ] && error "Aborted"

    echo ""
    log "Step 4: Partitioning disk"
    ${setupDisko}/bin/setup-disko "$DISK" "$HOST"
    success "Disk partitioned"

    log "Step 5: Copying configuration"
    ${copyConfiguration}/bin/copy-configuration
    success "Configuration copied"

    log "Step 6: Generating hardware config"
    ${generateHardwareConfig}/bin/generate-hardware-config "$HOST"
    success "Hardware config generated"

    echo ""
    log "Step 7: Setting up Secure Boot"
    ${setupSecureBoot}/bin/setup-secure-boot
    success "Secure Boot configured"

    echo ""
    log "Step 8: Installing NixOS (this takes several minutes)"
    ${installSystem}/bin/install-system "$HOST"
    success "Installation complete!"

    echo ""
    echo "=============================================="
    success "        NixOS Installation Successful!"
    echo "=============================================="
    echo ""
    echo "Installed host: $HOST"
    echo ""
    echo "Backup these files:"
    echo "  • /mnt/etc/nixos/secrets/keys/agenix.key"
    echo "  • /mnt/var/lib/sbctl"
    echo ""
    read -p "Reboot? (y/n): " REBOOT
    [[ "$REBOOT" =~ ^[Yy]$ ]] && reboot
  '';
}