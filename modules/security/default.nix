{ lib, ... }:

{
  imports = [
    ./hardening.nix
    ./apparmor.nix
  ];
}