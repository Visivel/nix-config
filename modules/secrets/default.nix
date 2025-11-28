{ config, lib, pkgs, username, inputs, ... }:

{
  age = {
    secrets = {
      git-name = {
        file = ../../secrets/git-name.age;
        owner = username;
      };
      
      git-email = {
        file = ../../secrets/git-email.age;
        owner = username;
      };
      
      user-password = {
        file = ../../secrets/user-password.age;
        owner = username;
      };
    };
    
    identityPaths = [
      "/etc/nixos/secrets/keys/agenix.key"
    ];
  };

  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${pkgs.system}.default
  ];
}