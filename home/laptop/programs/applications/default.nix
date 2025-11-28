{ config, lib, pkgs, inputs, ... }:

{
  imports = [ inputs.flatpak.homeManagerModules.nix-flatpak ];

  home.packages = with pkgs; [
    appimage-run
    librewolf
    prism-launcher
    legcord
    xclicker
    ayugram-desktop
    piper
  ];

  services.flatpak = {
    packages = [ 
      "com.github.tchx84.Flatseal"
      "org.vinegarhq.Sober"
    ];
  };
}
