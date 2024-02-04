{ pkgs, inputs, ...}: 
{
	imports = [ inputs.home-manager.nixosModules.home-manager	];
	users.users = {
		user = {
			initialPassword = "password";
			isNormalUser = true;
			shell = pkgs.fish;
			extraGroups = ["wheel" "network" "git"];
			packages = [ pkgs.home-manager ];
		};
	};

	home-manager.users.user = import ../home/default.nix;
}
