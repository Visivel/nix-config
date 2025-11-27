# NixOS Installer

This directory contains the installation system for the NixOS configuration.

## Usage

### Build Installation ISO
```bash
cd installer
nix build .#iso
```

### Run Interactive Installer
```bash
cd installer
nix run .#interactiveInstaller
```

### Development
```bash
cd installer
nix develop
```

## Files

- `flake.nix` - Installer flake configuration
- `lib/` - Installer helper functions
- `scripts/` - Utility scripts for building and running installer

## Scripts

- `scripts/generate-iso.sh` - Build installation ISO
- `scripts/install-system.sh` - Run interactive installer