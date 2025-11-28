{ lib, ... }:

{
  imports = [
    ./system
    ./network
    ./security
    ./secrets
    ./virtualization
  ];
}