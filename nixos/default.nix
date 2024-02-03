{config, lib, pkgs, inputs, outputs, ...}:
{
	imports = [
		./hardware-configuration.nix
		./encrypted-ephemeral-btrfs.nix
		./impermanence.nix
		./users.nix
		./wireless.nix
		./sops.nix
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

	nixpkgs = {
		config = {
			allowUnfree = true;
		};
	};

	networking = {
		hostName = "host";
		useDHCP = lib.mkDefault true;
	};
	
	home-manager.extraSpecialArgs = { inherit inputs outputs; };
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
		sops
		age
		gnupg
		ssh-to-age
	];

	system.stateVersion = "23.11";
}
