{
	config = {
		allowUnfree = true;
	};

	home = {
		username = "user";
		homeDirectory = "/home/user";
		stateVersion = "24.05";
	};

	programs.home-manager.enable = true;
	programs.git.enable = true;

	#systemd.user.startServices = "sd-switch";
}
