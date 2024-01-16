{config, lib, pkgs, ...}:
{
	imports = [
		./hardware-configuration.nix
		./disk-config.nix
		./ephemeral-btrfs.nix
	];

	boot = {
		kernelPackages = pkgs.linuxPackages_latest;
		loader = {
			systemd-boot = { 
				enable = true;
				consoleMode = "max";
			};
			efi.canTouchEfiVariables = true;
		};
	};

	networking = {
		hostName = "host";
		networkmanager.enable = true;
	};

	nix.settings = {
		experimental-features = "nix-command flakes";
		auto-optimise-store = true;
	};

	console = {
		font = "Lat2-Terminus16";
		keyMap = "fr-bepo";
	};

	users.users = {
		user = {
			initialPassword = "password";
			isNormalUser = true;
			extraGroups = ["wheel" "networkmanager"];
		};
	};

	environment.systemPackages = with pkgs; [
		vim
		git
		pciutils
		wget
		curl
	];

	system.stateVersion = "23.11";
}
