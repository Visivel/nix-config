{ config, lib, pkgs, ... }:

{
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
    
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  programs.virt-manager.enable = true;

  users.users.nixos.extraGroups = [ "libvirtd" ];
}