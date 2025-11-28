# NixOS Configuration

A personal NixOS configuration with desktop and laptop setups.

## Quick Start

### Update the system
```bash
nix flake update
sudo nixos-rebuild switch --flake .#desktop  # or laptop
```

## What's Included

- **Desktop setup**: High-performance configuration with KDE Plasma
- **Laptop setup**: Power-efficient configuration with wireless support
- **Security**: Hardened system settings
- **Development tools**: Git, direnv, and common utilities

## File Structure

- `hosts/` - Computer-specific settings (desktop/laptop)
- `home/` - User environment and applications
- `modules/` - Reusable system components
- `secrets/` - Encrypted configuration files
- `installer/` - Custom NixOS installer

## Installation

1. Build the installer ISO:
   ```bash
   cd installer
   chmod +x scripts/generate-iso.sh
   bash scripts/generate-iso.sh
   ```

2. Boot from the ISO and run:
   ```bash
   sudo install-os
   ```

## Adding a New Host

1. Copy an existing host from `hosts/` (desktop or laptop)
2. Modify the hardware configuration
3. Add the new host to [`flake.nix`](flake.nix)
4. Build and switch to the new configuration

## License

MIT License - see [`LICENSE`](LICENSE) file.