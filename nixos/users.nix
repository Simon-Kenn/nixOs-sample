{ pkgs, inputs, config, ...}: 
{
	imports = [ inputs.home-manager.nixosModules.home-manager	];

	sops.secrets.user_password.neededForUsers = true;

	users.users = {
		user = {
			isNormalUser = true;
			shell = pkgs.fish;
			extraGroups = ["wheel" "network" "git"];
			packages = [ pkgs.homesmanager ];
			hashedPasswordFile = config.sops.secrets.user_password.path;
		};
	};

	home-manager.users.user = import ../home/default.nix;
}
