{ inputs, outputs, ...}: {
	nixpkgs = {
		config = {
			allowUnfree = true;
		};
	};

	home = {
		username = "user";
		homeDirectory = "/home/user";
		stateVersion = "24.05";
		config = {
			allowUnfree = true;
		};
	};

	programs = {
		home-manager.enable = true;
		git.enable = true;
	};

	systemd.user.startServices = "sd-switch";
}
