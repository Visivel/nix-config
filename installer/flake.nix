{
  description = "NixOS Installation System";

  inputs = {
    root = {
      url = "..";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, root, nixpkgs, nixos-generators, disko, agenix, ... }:
    let
      nixosConfigurations = root.nixosConfigurations;

      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      installerLib = import ./lib { inherit inputs pkgs disko agenix; };
    in {
      packages.${system} = {
        inherit (installerLib)
          generateAgenixKey 
          encryptSecrets 
          setupDisko 
          copyConfiguration 
          generateHardwareConfig 
          setupSecureBoot 
          installSystem 
          interactiveInstaller;

        iso = nixos-generators.nixosGenerate {
          inherit system;
          specialArgs = { inherit inputs; username = "nixos"; };
          modules = [
            {
              networking = {
                hostName = "nixos-installer";
                networkmanager.enable = true;
                wireless.enable = false;
              };

              services = {
                xserver.enable = true;
                desktopManager.gnome.enable = true;
                displayManager = {
                  gdm.enable = true;
                  autoLogin = {
                    enable = true;
                    user = "nixos";
                  };
                };
              };

              programs.dconf.enable = true;

              security.sudo = {
                enable = true;
                wheelNeedsPassword = false;
              };

              users.users.nixos = {
                isNormalUser = true;
                extraGroups = [ "wheel" "networkmanager" ];
              };

              environment.systemPackages = with pkgs; [
                wget curl htop
                disko.packages.${system}.disko
                agenix.packages.${system}.default
                parted gptfdisk cryptsetup
                e2fsprogs btrfs-progs dosfstools
                rsync networkmanager
                nixos-install-tools sbctl age mkpasswd
              ] ++ (builtins.attrValues installerLib);

              nix.settings = {
                experimental-features = [ "nix-command" "flakes" ];
                warn-dirty = false;
              };

              environment.etc."nixos-config".source = root;

              systemd.tmpfiles.rules = [
                "d /etc/agenix-keys 0755 root root -"
                "L+ /root/nixos-config - - - - /etc/nixos-config"
              ];

              boot.supportedFilesystems = [
                "btrfs" "ext4" "xfs" "ntfs" "vfat"
              ];
            }
          ];
          format = "install-iso";
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nixos-generators.packages.${system}.nixos-generators
          disko.packages.${system}.disko
          agenix.packages.${system}.default
        ];

        shellHook = ''
          echo "🔧 NixOS Installer Development Environment"
          echo "Available commands:"
          echo "  nix build .#iso"
          echo "  nix run .#interactiveInstaller"
        '';
      };
    };
}