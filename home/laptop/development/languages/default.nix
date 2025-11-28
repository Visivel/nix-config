{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    nodejs_24
    zulu25
    python3
    bun
  ];
}