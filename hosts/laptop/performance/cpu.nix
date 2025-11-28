{ config, lib, pkgs, ... }:

{
  services.power-profiles-daemon.enable = false;
  services.auto-cpufreq.enable = false;

  services.irqbalance.enable = true;

  boot.kernelParams = [
    "processor.max_cstate=1"
    "idle=poll"
    "amd_pstate=active"
    "amd_pstate.shared_mem=1"
  ];

  boot.kernelModules = [ "k10temp" "amd_pstate" ];

  hardware.cpu.amd = {
    updateMicrocode = true;
    sev.enable = false;
  };

  boot.extraModprobeConfig = ''
    options amd_pstate shared_mem=1
  '';

  environment.etc."sysctl.d/99-amd-laptop.conf".text = ''
    vm.swappiness=60
    kernel.sched_migration_cost_ns=5000000
    kernel.sched_autogroup_enabled=1
  '';

  systemd.tmpfiles.rules = [
    "w /proc/sys/kernel/sched_migration_cost_ns - - - - 5000000"
  ];
}