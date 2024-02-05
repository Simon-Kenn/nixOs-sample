{
	disko.devices = {
    disk = {
			sda = {
        type = "disk";
        device = "/dev/disk/by-id/ata-Micron_1100_MTFDDAV256TBN_174619CDC946";
        content = {
          type = "gpt";
          partitions = {
            esp = {
              priority = 1;
              start = "1M";
              end = "128M";
              type = "EF00";
              content = {
                type = "filesystem";
								extraArgs = ["-n NIXBOOT"];
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
								type = "luks";
								name = "crypted";
								settings = {
									allowDiscards = true;
								};
								content = {
									type = "btrfs";
                	extraArgs = [ "-f" "-L NIXROOT"]; 
									postCreateHook = /* sh */ ''
										MNTPOINT=$(mktemp -d)
										mount "/dev/mapper/crypted" "$MNTPOINT" -o subvol=/
										trap 'umount $MNTPOINT; rm -rf $MNTPOINT' EXIT
										btrfs subvolume snapshot -r $MNTPOINT/root $MNTPOINT/root-blank
									'';
                	subvolumes = {
										"/root" = {
                  	  mountpoint = "/";
											mountOptions = ["compress=zstd" "noatime"];
                  	};
                  	"/nix" = {
                  	  mountpoint = "/nix";
                  	  mountOptions = [ "compress=zstd" "noatime"];
                  	};
                  	"/persist" = {
                  	  mountpoint = "/persist";
                  	  mountOptions = [ "compress=zstd" "noatime" ];
                  	};
                  	"/swap" = {
                  	  mountpoint = "/.swapvol";
                  	  swap.swapfile.size = "20M";
											mountOptions = [ "noatime" ];
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

	fileSystems."/persist".neededForBoot = true;

}
