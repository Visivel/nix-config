{ config, lib, pkgs, ... }:

{
  networking = {
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };

    wireless.iwd = {
      enable = true;
      settings = {
        IPv4 = {
          Dhcp = "internal";
        };
        Settings = {
          AutoConnect = true;
        };
      };
    };
  };

  services.connman.enable = false;

  hardware.wirelessRegulatoryDatabase = true;
}