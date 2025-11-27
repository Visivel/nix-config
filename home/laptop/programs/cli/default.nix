{ config, lib, pkgs, ... }:

{
  imports = [
    ./shell.nix
    ./utilities.nix
    ./search.nix
  ];
}