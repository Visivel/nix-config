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

  fonts.packages = with pkgs; [ roboto ];

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
    kdenlive
    kdepim-addons
    kdepim-runtime
    kget
    kgpg
    khelpcenter
    kmail
    kmouth
    konversation
    korganizer
    krdc
    krfb
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
    kdeconnect-kde
    kolourpaint
    kdeplasma-addons
    kcalc
  ];

  programs.dconf.enable = true;
}
