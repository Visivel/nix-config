{ config, lib, pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      curl wget git killall file which age
      pciutils usbutils tree sbctl ps_mem
      devenv
    ];

    defaultPackages = [ ];

    variables = {
      EDITOR = "nano";
      BROWSER = "chromium";
    };
  };

  programs = {
    nano.enable = true;
    git.enable = true;
    dconf.enable = true;
  };

  services = {
    flatpak.enable = true;
    locate = {
      enable = true;
      package = pkgs.mlocate;
      interval = "hourly";
      pruneBindMounts = true;
    };
  };
}
