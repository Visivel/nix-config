{ config, pkgs, lib, ... }:

{
  programs.dconf.profiles.user.databases = [{
    settings = {
      "org/gnome/settings-daemon/plugins/power" = {
        idle-dim = false;
        sleep-inactive-ac-type = "nothing";
      };
    };
  }];
}