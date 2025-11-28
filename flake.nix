{
  description = "Personal NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    flatpak.url = "github:gmodena/nix-flatpak";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, disko, agenix, nixos-hardware, flatpak, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      flake =
        let
          lib = nixpkgs.lib.extend (final: prev:
            import ./lib { lib = final; }
          );

          username = "nixos";
          system = "x86_64-linux";
          
          commonArgs = {
            inherit inputs username;
          };

          mkHostConfig = hostType: hardwareModules:
            lib.helpers.mkHost inputs {
              inherit system username;
              modules = [
                disko.nixosModules.disko
                agenix.nixosModules.default
                home-manager.nixosModules.home-manager
                ./modules
                (./hosts + "/${hostType}")
                {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    backupFileExtension = "backup";
                    extraSpecialArgs = commonArgs;
                    users.${username} = import (./home + "/${hostType}");
                  };
                }
              ] ++ hardwareModules;
            };
          
        in {
          inherit lib;
          
          nixosModules.default = import ./modules;
          
          nixosConfigurations = {
            desktop = mkHostConfig "desktop" [
              nixos-hardware.nixosModules.common-cpu-amd
              nixos-hardware.nixosModules.common-pc-ssd
            ];
            
            laptop = mkHostConfig "laptop" [
              nixos-hardware.nixosModules.common-cpu-amd
              nixos-hardware.nixosModules.common-pc-laptop
              nixos-hardware.nixosModules.common-pc-laptop-ssd
            ];
          };
        };
    };
}