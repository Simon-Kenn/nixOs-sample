{config, lib, pkgs, ...}:
{
	imports = [
		./hardware-configuration.nix
		./disk-config.nix
	];

	boot.loader.grub = {
		enable = true;
		efiSupport = true;
		efiInstallAsRemovable = true;
		device = "nodev";
	};

	networking = {
		hostName = "host";
	};

	user.users = {
		user = {
			initialPassword = "passworde";
			isNormalUser = true;
			extraGroups = ["wheel" "video" "audio" "kvm" "networkmanager"];
			shell = pkgs.fish;
		};
	};

	system.stateVersion = "23.11";
}
