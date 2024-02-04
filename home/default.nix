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
		fish = {
			enable = true;
			shellInit = ''
				export GPG_TTY=$(tty)
			'';
		};
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
		pinentryFlavor = "curses";
	};
 
	systemd.user.services = {
		link-gnupg-sockets = {
			Unit = {
				Description = "link gnupg sockets from /run to /home";	
			};
			Service = {
				Type = "oneshot";
				ExecStart = "${pkgs.coreutils}/bin/ln -Tfs /run/user/%U/gnupg %h/.gnupg-sockets";
        ExecStop = "${pkgs.coreutils}/bin/rm $HOME/.gnupg-sockets";
        RemainAfterExit = true;
			};
			Install.WantedBy = [ "default.target" ];
		};
	};

	systemd.user.startServices = "sd-switch";
}
