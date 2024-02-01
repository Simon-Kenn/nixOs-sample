{config, lib, pkgs, ...}:
{
	imports = [
		./hardware-configuration.nix
		./encrypted-ephemeral-btrfs.nix
		./impermanence.nix
		./users.nix
		./wireless.nix
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
		useDHCP = lib.mkDefault true;
	};

	hardware.enableRedistributableFirmware = true;

	nix.settings = {
		experimental-features = "nix-command flakes";
		auto-optimise-store = true;
	};

	console = {
		font = "Lat2-Terminus16";
		keyMap = "fr-bepo";
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
