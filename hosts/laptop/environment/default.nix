{ config, pkgs, lib, ... }:

{
  imports = [
    ./gnome.nix
    ./extensions.nix
    ./xdg.nix
  ];
}