{ lib, config, ... }:
{
	boot.initrd = {
		enable = true;
		supportedFilesystems = ["btrfs"];

		systemd.services.restore-root = {
			description = "Rollback btrfs rootfs";
			wantedBy = [ "intitrd.target" ];
			requires = [ 
				"dev-disk-by\\x2dlabel-root.device"
			];
			after = [
				"dev-disk-by\\x2dlabel-root.device"
				#"systemd-cryptsetup@${config.networking.hostName}.service"
			];
			before = [ "sysroot.mount" ];
			unitConfig.DefaultDependencies = "no";
			serviceConfig.Type = "oneshot";
			script =  /* bash */ ''
				mkdir /tmp -p
				MNTPOINT=$(mktemp -d)
    		(
    		  mount -t btrfs -o subvol=/ /dev/disk/by-label/root "$MNTPOINT"
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
		};
	};
}
