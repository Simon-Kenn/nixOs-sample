{
	config = {
		allowUnfree = true;
	};

	home = {
		username = "user";
		homeDirectory = "/home/user";
	};

	programs.home-manager.enable = true;
	programs.git.enable = true;

	systemd.user.startServices = "sd-switch";

	home.stateVersion = "24.05";
}
