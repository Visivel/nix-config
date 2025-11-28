{ config, lib, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa
        rocmPackages.clr.icd
      ];
    };
    
    amdgpu = {
      opencl.enable = true;
    };
  };

  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
    RADV_PERFTEST = "sam,nggc,rt";
    RADV_DEBUG = "zerovram";
    mesa_glthread = "true";
    AMD_DEBUG = "nodma";
  };

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  boot.kernelParams = [
    "amdgpu.ppfeaturemask=0xffffffff"
    "amdgpu.gpu_recovery=1"
    "amdgpu.dpm=1"
    "amdgpu.dc=1"
  ];

  environment.systemPackages = with pkgs; [
    rocmPackages.clr
    rocmPackages.rocm-runtime
    vulkan-tools
    vulkan-loader
    vulkan-validation-layers
  ];
}