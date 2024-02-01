{ lib, config, inputs, ... }:
let
  wipeScript = /* bash */ ''
    mkdir /tmp -p
    MNTPOINT=$(mktemp -d)
    (
      mount -t btrfs -o subvol=/ /dev/disk/by-label/NIXROOT "$MNTPOINT"
      trap 'umount "$MNTPOINT"' EXIT

      echo "Creating needed directories"
      mkdir -p "$MNTPOINT"/persist/var/{log,lib/{nixos,systemd}}

      echo "Cleaning root subvolume"
      btrfs subvolume list -o "$MNTPOINT/root" | cut -f9 -d ' ' |
      while read -r subvolume; do
        btrfs subvolume delete "$MNTPOINT/$subvolume"
      done && btrfs subvolume delete "$MNTPOINT/root"

      echo "Restoring blank subvolume"
      btrfs subvolume snapshot "$MNTPOINT/root-blank" "$MNTPOINT/root"
    )
  '';
  phase1Systemd = config.boot.initrd.systemd.enable;
in
{
	imports = [
		inputs.disko.nixosModules.disko
	];
  boot.initrd = {
    supportedFilesystems = [ "btrfs" ];
    postDeviceCommands = lib.mkIf (!phase1Systemd) (lib.mkBefore wipeScript);
    systemd.services.restore-root = lib.mkIf phase1Systemd {
      description = "Rollback btrfs rootfs";
      wantedBy = [ "initrd.target" ];
      requires = [
        "dev-disk-by\\x2dlabel-NIXROOT.device"
      ];
      after = [
        "dev-disk-by\\x2dlabel-NIXROOT.device"
        "systemd-cryptsetup@NIXROOT.service"
      ];
      before = [ "sysroot.mount" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = wipeScript;
    };
  };

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
