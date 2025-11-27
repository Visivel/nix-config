{ config, lib, pkgs, ... }:

{
  imports = [
    ./gpu.nix
    ./audio.nix
  ];

  services.fwupd.enable = true;

  hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = false;
    firmware = with pkgs; [ linux-firmware ];
  };
}