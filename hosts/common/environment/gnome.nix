{ config, pkgs, lib, ... }:

{
  services = {
    xserver = {
      enable = true;
      xkb.layout = "br";
      excludePackages = [ pkgs.xterm ];
      desktopManager.xterm.enable = false;
    };

    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };

  environment.gnome.excludePackages = with pkgs; [
    baobab eog epiphany evince file-roller geary
    gnome-builder gnome-calendar gnome-characters gnome-chess
    gnome-clocks gnome-connections gnome-contacts gnome-font-viewer
    gnome-logs gnome-mahjongg gnome-maps gnome-mines gnome-music
    gnome-photos gnome-remote-desktop gnome-secrets gnome-software
    gnome-sudoku gnome-tour gnome-usage gnome-user-docs gnome-weather
    papers polari seahorse simple-scan snapshot totem yelp
  ];

  environment.systemPackages = with pkgs; [
    decibels gnome-calculator gnome-console gnome-shell-extensions
    gnome-system-monitor gnome-text-editor gnome-tweaks loupe
    showtime nautilus
  ];

  programs.dconf.enable = true;
}