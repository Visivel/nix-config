{ config, pkgs, lib, ... }:

{
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
  };
}