{ config, lib, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia_x11
        nvidia_x11.libgl
        vulkan-loader
        vulkan-tools
      ];
    };
  };

  environment.variables = {
    NVIDIA_VISIBLE_DEVICES = "all";
    __GL_THREADED_OPTIMIZATIONS = "1";
    __GL_SHADER_DISK_CACHE = "1";
  };

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
  ];

  environment.systemPackages = with pkgs; [
    nvidia_x11
    nvidia_x11.libgl
    vulkan-tools
    vulkan-loader
    nvidia-utils
  ];
}
