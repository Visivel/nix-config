{ config, lib, pkgs, ... }:

{
  imports = [
    ./gpu.nix
    ./audio.nix
    ./power.nix
    ./wireless.nix
  ];

  services.fwupd.enable = true;

  hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = false;
    firmware = with pkgs; [ linux-firmware ];
  };
}