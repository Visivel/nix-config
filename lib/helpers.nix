{ lib }:

with lib;

{
  mkUser = pkgs: { name, groups ? [], shell ? "bash", ... }@args:
    {
      users.users.${name} = {
        isNormalUser = true;
        extraGroups = [ "wheel" ] ++ groups;
        shell = pkgs.${shell};
      } // (removeAttrs args [ "name" "groups" "shell" ]);
    };

  mkHost = inputs: { system, modules, username }:
    lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs username; };
      modules = modules;
    };
}