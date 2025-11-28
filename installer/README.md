# NixOS Installer

Custom installer for this NixOS configuration.

## Quick Start

### Create installation ISO
```bash
cd installer
chmod +x scripts/generate-iso.sh
bash scripts/generate-iso.sh
```

The ISO will be created in `result/iso/` - burn it to a USB drive or use it in a VM.

### Install NixOS
Boot from the ISO and run:
```bash
sudo install-os
```

This will guide you through the installation process.

## What it does

- Creates a bootable NixOS installer
- Includes this configuration pre-loaded
- Provides an interactive installation script
- Sets up disk partitioning and system installation

## Files

- [`flake.nix`](flake.nix) - Installer configuration
- `scripts/` - Installation helper scripts
- `lib/` - Installer utilities