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

		wireless = {
			enable = true;
			fallbackToWPA2 = false;
			
			networks = {
				"Bbox-5c32B2F3" = {
					psk = "A2C44EC1ECF3EEAA2471617E2EDC1F";
				};
			};

			allowAuxiliaryImperativeNetworks = true;
			userControlled = {
				enable = true;
				group = "network";
			};
			extraConfig = ''
				update_config=1
			'';
		};
	};

	users.groups.network = {};

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
			shell = pkgs.fish;
			extraGroups = ["wheel" "networkmanager"];
		};
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
