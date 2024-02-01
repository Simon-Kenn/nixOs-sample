{pkgs, ...}: {
	users.users = {
		user = {
			initialPassword = "password";
			isNormalUser = true;
			shell = pkgs.fish;
			extraGroups = ["wheel" "network"];
		};
	};
}
