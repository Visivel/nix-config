{ config, lib, pkgs, username, inputs, ... }:

{
  imports = [
    ./programs
    ./development
  ];

  programs.home-manager.enable = true;

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
    pointerCursor = {
      name = "macOS-White";
      package = pkgs.apple-cursor;
      size = 20;
      gtk.enable = true;
    };
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
      publicShare = null;
      templates = null;
    };
  };

  gtk = {
    enable = true;
    cursorTheme = {
      name = "macOS-White";
      package = pkgs.apple-cursor;
      size = 20;
    };
  };
}