{ config, pkgs, lib, ... }:

{
  programs.dconf.profiles.user.databases = [{
    settings = {
      "org/gnome/settings-daemon/plugins/power" = {
        idle-dim = true;
        sleep-inactive-ac-type = "suspend";
        sleep-inactive-battery-type = "suspend";
        sleep-inactive-battery-timeout = lib.gvariant.mkInt32 900;
      };
    };
  }];
}