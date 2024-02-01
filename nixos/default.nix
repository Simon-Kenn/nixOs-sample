{config, lib, pkgs, ...}:
{
	imports = [
		./hardware-configuration.nix
		./enycrypted-ephemeral-btrfs.nix
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


	programs.fish = {
		enable = true;
		vendor = {
			completions.enable = true;
			config.enable = true;
			functions.enable = true;
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
