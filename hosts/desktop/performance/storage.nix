{ config, lib, pkgs, ... }:

{
  services.fstrim = {
    enable = true;
    interval = "daily";
  };
  
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };
  
  boot.kernel.sysctl = {
    "vm.dirty_expire_centisecs" = 3000;
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="block", ATTR{queue/scheduler}=="mq-deadline", ATTR{queue/scheduler}="kyber"
    SUBSYSTEM=="block", ATTR{queue/scheduler}=="bfq", ATTR{queue/scheduler}="kyber"
  '';
}