{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    fd
    ripgrep
  ];

  programs.fzf = {
    enable = true;
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      pager = "less -FR";
    };
  };
}