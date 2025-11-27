{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sdX";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" "fmask=0077" "dmask=0077" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                extraOpenArgs = [ 
                  "--allow-discards" 
                  "--perf-no_read_workqueue"
                  "--perf-no_write_workqueue"
                ];
                settings = {
                  allowDiscards = true;
                  bypassWorkqueues = true;
                };
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" "--csum xxhash" ];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [ 
                        "compress=zstd:1" 
                        "noatime" 
                        "space_cache=v2" 
                        "discard=async"
                        "ssd"
                      ];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ 
                        "compress=zstd:1" 
                        "noatime" 
                        "space_cache=v2" 
                        "discard=async"
                        "ssd"
                      ];
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [ 
                        "compress=zstd:3" 
                        "noatime" 
                        "space_cache=v2" 
                        "discard=async"
                        "ssd"
                      ];
                    };
                    "/var" = {
                      mountpoint = "/var";
                      mountOptions = [ 
                        "compress=zstd:1" 
                        "noatime" 
                        "space_cache=v2" 
                        "discard=async"
                        "ssd"
                      ];
                    };
                    "/var/log" = {
                      mountpoint = "/var/log";
                      mountOptions = [ 
                        "compress=zstd:1" 
                        "noatime" 
                        "space_cache=v2" 
                        "discard=async"
                        "ssd"
                      ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
