{
  disko.devices = {
    disk = {
			sda = {
        type = "disk";
        device = "/dev/disk/by-id/Micron_1100_MTFD";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "128M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; 
                subvolumes = {
                  "/root" = {
										mountOptions = ["compress=zstd" "noatime"];
                    mountpoint = "/";
                  };
                  "/nix" = {
                    mountOptions = [ "compress=zstd" "noatime"];
                    mountpoint = "/nix";
                  };
                  "/persist" = {
                    mountOptions = [ "compress=zstd" "noatime" ];
                    mountpoint = "/persist";
                  };
                  "/swap" = {
                    swap.swapfile.size = "20M";
                    mountpoint = "/.swapvol";
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
