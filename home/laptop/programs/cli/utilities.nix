{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    jq
    unzip
    zip
    fastfetch
  ];
}