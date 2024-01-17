{ lib, config, ... }:
let
	eraseYourDarlings = /* bash */ ''
		mkdir -p /mnt	
    mount -o subvol=/ /dev/disk/by-label/root /mnt

    btrfs subvolume list -o /mnt/root | cut -f9 -d' ' |
    while read subvolume; do
      echo "deleting /$subvolume subvolume..."
      btrfs subvolume delete "/mnt/$subvolume"
    done &&
    echo "deleting /root subvolume..." &&
    btrfs subvolume delete /mnt/root

    echo "restoring blank /root subvolume..."
    btrfs subvolume snapshot /mnt/root-blank /mnt/root

    umount /mnt
	'';
in
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
			script = eraseYourDarlings;
		};
	};
}
