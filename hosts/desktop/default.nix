{ config, lib, pkgs, inputs, username, ... }:

{
  imports = [
    ../common
    ./system
    ./devices
    ./performance
  ];
}