{ config, lib, pkgs, username, ... }:

{
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.bash;
  };
}