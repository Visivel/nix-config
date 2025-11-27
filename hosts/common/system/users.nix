{ config, lib, pkgs, username, ... }:

lib.helpers.mkUser pkgs {
  name = username;
  groups = [ "networkmanager" "video" "audio" ];
  hashedPasswordFile = config.age.secrets.user-password.path;
}