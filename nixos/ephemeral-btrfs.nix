{ lib, config, ... }:
let
  wipeScript = /* bash */ ''
    #mkdir /tmp -p
    #MNTPOINT=$(mktemp -d)
    #(
    #  mount -t btrfs -o subvol=/ /dev/disk/by-label/root "$MNTPOINT"
    #  trap 'umount "$MNTPOINT"' EXIT

    #  echo "Creating needed directories"
    #  mkdir -p "$MNTPOINT"/persist/var/{log,lib/{nixos,systemd}}

    #  echo "Cleaning root subvolume"
    #  btrfs subvolume list -o "$MNTPOINT/root" | cut -f9 -d ' ' |
    #  while read -r subvolume; do
		#		echo "  Deleting /$subvolume subvolume..."
    #    btrfs subvolume delete "$MNTPOINT/$subvolume"
    #  done && echo "  Deleting root subvolume" && btrfs subvolume delete "$MNTPOINT/root"

    #  echo "Restoring blank subvolume"
    #  btrfs subvolume snapshot "$MNTPOINT/root-blank" "$MNTPOINT/root"
    #)
		mkdir -p /mnt

    mount -o subvol=/ /dev/disk/by-label/NIXROOT /mnt

    btrfs subvolume list -o /mnt/root |
    cut -f9 -d' ' |
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
  phase1Systemd = config.boot.initrd.systemd.enable;
in
{
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
#        "systemd-cryptsetup@${hostname}.service"
      ];
      before = [ "sysroot.mount" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = wipeScript;
    };
  };
}
