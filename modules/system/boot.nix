{ lib, pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = lib.mkForce false;

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };

      limine = {
        enable = true;
        efiSupport = true;
        secureBoot.enable = true;
        maxGenerations = 10;

        style = {
          wallpapers = [ ];
          backdrop = "000000";
        };
      };
    };

    initrd.systemd.enable = true;

    kernelPackages = pkgs.linuxPackages_latest;

    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "ip_tables"
      "iptable_filter"
      "iptable_mangle"
      "iptable_nat"
    ];

    kernel.sysctl = {
      "vm.dirty_ratio" = 15;
      "vm.dirty_background_ratio" = 5;
      "kernel.unprivileged_userns_clone" = 1;
    };

    tmp = {
      useTmpfs = true;
      tmpfsSize = "75%";
    };
  };
}