{ config, lib, pkgs, ... }:

{
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  
  system.stateVersion = "25.11";
}