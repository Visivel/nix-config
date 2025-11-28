{ config, lib, pkgs, ... }:

{
  imports = [
    ./cli
    ./applications
  ];
}