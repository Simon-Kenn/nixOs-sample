{ pkgs, ...}: {
	users.users = {
		user = {
			initialPassword = "password";
			isNormalUser = true;
			extraGroups = ["wheel" "network" "git"];
		};


		packages = [ pkgs.home-manager ];
	};

	home-manager.users.user = import ../home;
}
