{ config, lib, pkgs, ... }:

{
  imports = [
    ./git.nix
    ./direnv.nix
  ];

  home.packages = with pkgs; [
    vscode
    delta
    lazygit
    gh
  ];
}