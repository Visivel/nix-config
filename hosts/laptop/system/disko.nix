{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          partitions = {
            linux = {
              type = "partition";
              device = "/dev/nvme0n1p9";
              content = {
                type = "filesystem";
                format = "btrfs";
                mountpoint = "/";
                subvolumes = {
                  "/root" = { mountpoint = "/"; };
                  "/nix" = { mountpoint = "/nix"; };
                  "/home" = { mountpoint = "/home"; };
                  "/var" = { mountpoint = "/var"; };
                  "/var/log" = { mountpoint = "/var/log"; };
                };
                mountOptions = [ "compress=zstd:1" "noatime" "space_cache=v2" "discard=async" "ssd" ];
              };
            };
          };
        };
      };
    };
  };
}
