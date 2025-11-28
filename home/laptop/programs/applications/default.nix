{ config, lib, pkgs, inputs, ... }:

{
  imports = [ inputs.flatpak.homeManagerModules.nix-flatpak ];

  home.packages = with pkgs; [
    appimage-run
    ungoogled-chromium
  ];
  
  services.flatpak = {
    packages = [
      "org.equicord.equibop"
    ];
    
    overrides = {
      "org.equicord.equibop" = {
        Context = {
          filesystems = [
            "host"
            "host-etc"
          ];
        };
      };
    };
  };
}
