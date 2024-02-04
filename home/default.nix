{ inputs, pkgs, lib, ...}:
{
	imports = [
		inputs.impermanence.nixosModules.home-manager.impermanence
	];

	nixpkgs = {
		config = {
			allowUnfree = true;
		};
	};

	home = {
		username = "user";
		homeDirectory = "/home/user";
		stateVersion = "24.05";

		persistence = {
			"/persist/home/user" = {
				directories = [
					"Codes"
					".ssh"
				];
				allowOther = true;
			};
		};
	};

	nix = {
		package = lib.mkDefault pkgs.nix;
		settings = {
			experimental-features = [ "nix-command" "flakes" "repl-flake" ];
		};
	};

	programs = {
		home-manager.enable = true;
		git.enable = true;
		gpg = {
			enable = true;
			publicKeys = [{
				source = ./pgp.asc;
				trust = 5;	
			}];
		};
	};

	services.gpg-agent = {
		enable = true;
		enableSshSupport = true;
		pinentryFlavor = "curses";
	};

	systemd.user.startServices = "sd-switch";
}
