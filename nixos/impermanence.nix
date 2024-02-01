{lib, inputs, config, ...}: {
	imports = [
		inputs.impermanence.nixosModules.impermanence
	];

	environment.persistence = {
		"/persist" = {
			directories = [
				"/var/lib/systemd"
				"/var/lib/nixos"
				"/var/log"
				"/srv"
			];
			users.user = {
				directories = [
					"nixos-sample"
				];
			};
		};
	};
	programs.fuse.userAllowOther = true;
}
