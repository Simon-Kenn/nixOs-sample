{
  disko.devices = {
    disk = {
			sda = {
        type = "disk";
        device = "/dev/disk/by-id/ata-Micron_1100_MTFDDAV256TBN_174619CDC946";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
							label = "boot";
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
							label = "root";
              content = {
								#type = "luks";
								#name = "crypted";
								#settings = {
								#	allowDiscards = true;
								#};
								#content = {
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
											mountOptions = [ "noatime" ];
                  	  swap.swapfile.size = "20M";
                  	  mountpoint = "/.swapvol";
                  	};
									#};
                };
              };
            };
          };
        };
      };
    };
  };
	#fileSystems."./persist".neededForBoot = true;
}
