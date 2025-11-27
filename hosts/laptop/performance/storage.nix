{ config, lib, pkgs, ... }:

{
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };
  
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };
  
  boot.kernel.sysctl = {
    "vm.dirty_expire_centisecs" = 6000;
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="block", ATTR{queue/scheduler}=="mq-deadline", ATTR{queue/scheduler}="kyber"
    SUBSYSTEM=="block", ATTR{queue/scheduler}=="bfq", ATTR{queue/scheduler}="kyber"
  '';
}