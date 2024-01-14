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

	nix.settings = {
		experimental-features = "nix-command flakes";
		auto-optimise-store = true;
	};

	console = {
		keyMap = "fr-bepo";
	};

	users.users = {
		user = {
			initialPassword = "password";
			isNormalUser = true;
			extraGroups = ["wheel" "video" "audio" "kvm" "networkmanager"];
			shell = pkgs.fish;
		};
	};

	programs.fish.enable = true;

	system.stateVersion = "23.11";
}
