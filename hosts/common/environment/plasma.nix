{ config, pkgs, lib, ... }:

{
  services = {
    xserver = {
      enable = true;
      xkb.layout = "br";
      excludePackages = [ pkgs.xterm ];
    };

    displayManager = {
      sddm.enable = true;
      sddm.wayland.enable = true;
    };

    desktopManager.plasma6.enable = true;
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    akregator
    discover
    dolphin-plugins
    dragon
    elisa
    gwenview
    juk
    kaddressbook
    kalarm
    kamera
    kcharselect
    kcolorchooser
    kdeconnect-kde
    kdenlive
    kdepim-addons
    kdepim-runtime
    kget
    kgpg
    khelpcenter
    kmail
    kmouth
    kolourpaint
    konversation
    korganizer
    krdc
    krfb
    kdeplasma-addons
    ksshaskpass
    kwallet
    kwalletmanager
    print-manager
    skanpage
    sweeper
    telly-skout
  ];

  environment.systemPackages = with pkgs.kdePackages; [
    dolphin
    kate
    kcalc
    konsole
    ark
    okular
    spectacle
  ];

  programs.dconf.enable = true;
}