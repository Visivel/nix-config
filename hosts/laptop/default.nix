{ config, lib, pkgs, inputs, username, ... }:

{
  imports = [
    ../common
    ./system
    ./environment
    ./devices
    ./performance
  ];
}