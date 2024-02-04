{ pkgs, inputs, config, ...}: 
{
	imports = [ inputs.home-manager.nixosModules.home-manager	];

	sops.secrets.user_password = {
		sopsFile = ../secrets/secrets.yaml;
		neededForUsers = true;
	};

	users.users = {
		user = {
			isNormalUser = true;
			shell = pkgs.fish;
			extraGroups = ["wheel" "network" "git"];
			packages = [ pkgs.home-manager ];
			hashedPasswordFile = config.sops.secrets.user_password.path;
		};
	};

	home-manager.users.user = import ../home/default.nix;
}
