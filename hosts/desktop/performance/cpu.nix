{ config, lib, pkgs, ... }:

{
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
    powertop.enable = false;
  };

  services.power-profiles-daemon.enable = false;
  services.tlp.enable = false;
  services.auto-cpufreq.enable = false;

  services.irqbalance.enable = true;

  boot.kernelParams = [
    "preempt=full"
    "threadirqs"
    "split_lock_detect=off"
    "nohz_full=1-7"
    "rcu_nocbs=1-7"
    "processor.max_cstate=1"
    "idle=poll"
    "amd_pstate=active"
    "amd_pstate.shared_mem=1"
  ];

  boot.kernelModules = [ "k10temp" "amd_pstate" "zenpower" ];

  hardware.cpu.amd = {
    updateMicrocode = true;
    sev.enable = false;
  };

  boot.extraModprobeConfig = ''
    options amd_pstate shared_mem=1
  '';

  environment.etc."sysctl.d/99-amd-performance.conf".text = ''
    vm.swappiness=10
    kernel.sched_migration_cost_ns=5000000
    kernel.sched_autogroup_enabled=0
    kernel.numa_balancing=0
  '';

  systemd.services.cpu-performance-tuning = {
    description = "CPU Performance Tuning Service";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
        echo "performance" > "$cpu" 2>/dev/null || true
      done

      for cpu in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference; do
        echo "performance" > "$cpu" 2>/dev/null || true
      done

      if [ -f /sys/devices/system/cpu/cpufreq/boost ]; then
        echo 1 > /sys/devices/system/cpu/cpufreq/boost
      fi

      for cpu in /sys/devices/system/cpu/cpu*/power/energy_perf_bias; do
        echo 0 > "$cpu" 2>/dev/null || true
      done
    '';
  };

  systemd.tmpfiles.rules = [
    "w /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor - - - - performance"
    "w /proc/sys/kernel/sched_migration_cost_ns - - - - 5000000"
  ];
}