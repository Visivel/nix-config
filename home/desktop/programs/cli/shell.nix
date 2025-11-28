{ config, lib, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    
    shellAliases = {
      grep = "grep --color=auto";
      df = "df -h";
      du = "du -h";
      free = "free -h";
      switch = "sudo nixos-rebuild switch --flake /etc/nixos#desktop --impure";
      boot = "sudo nixos-rebuild boot --flake /etc/nixos#desktop --impure";
      update = "nix flake update";
      gc = "nix-collect-garbage -d";
    };
    
    initExtra = ''
      export HISTCONTROL=ignoredups:erasedups
      export HISTSIZE=10000
      export HISTFILESIZE=20000
      shopt -s histappend
      
      fastfetch
    '';
  };
}