{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  boot = {
    kernelParams = [
      "amd_iommu=on"
      "iommu=pt"
    ];
    
    kernelModules = [
      "kvm-amd"
      "vfio-pci"
    ];
  };
}