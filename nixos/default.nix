{config, lib, pkgs, ...}:
{
	imports = [
		./hardware-configuration.nix
		./disk-config.nix
	];

	boot.loader.grub = {
		efiSupport = true;
		efiInstallAsRemovable = true;
		device = "nodev";
	};

	networking = {
		hostName = "hostname";
	};

	system.stateVersion = "23.11";
}
