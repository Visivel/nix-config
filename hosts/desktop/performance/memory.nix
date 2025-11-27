{ config, lib, pkgs, ... }:

{
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 80;
    priority = 10;
  };

  boot.kernel.sysctl = {
    "vm.vfs_cache_pressure" = 50;
    "vm.dirty_writeback_centisecs" = 500;
    "vm.page-cluster" = 0;
    "vm.overcommit_memory" = 1;
    "vm.overcommit_ratio" = 50;
  };
}