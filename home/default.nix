{
	inputs,
	outputs,
	lib,
	config,
	pkgs,
	...
}: {
	imports = [];

	nixpkgs = {
		overlays = [
			outputs.overlays.additions
			outputs.overlays.modifications
		];
		config = {
			allowUnfree = true;
			allowUnfreePredicate = _: true;
		};

		home = {
			username = "sikenn";
			homeDirectory = "/home/sikenn";
		};

		programs.home-manager.enable = true;
		programs.git.enable = true;
		systemd.user.startServices = "sd-switch";

		home.stateVersion = "24.05";
	};
}
