{ pkgs, ...}: {
	users.users = {
		user = {
			initialPassword = "password";
			isNormalUser = true;
			extraGroups = ["wheel" "network" "git"];
		};

		home-manager.users.user = import ../home;

		packages = [ pkgs.home-manager ];
	};
}
