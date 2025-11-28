{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    nodejs_24
    zulu25
    zulu21
    zulu17
    python3
    bun
  ];
}
