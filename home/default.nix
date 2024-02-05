{ inputs, pkgs, lib, ...}:
{
	imports = [
		inputs.impermanence.nixosModules.home-manager.impermanence
		./gpg.nix
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
		fish.enable = true;
	};
 
	systemd.user.startServices = "sd-switch";
}
