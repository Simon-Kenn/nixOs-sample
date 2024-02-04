{config, ...}: {
	sops.secrets.wireless.neededForUsers = true;
	networking = {
		wireless = {
			enable = true;
			environmentFile = config.sops.secrets.wireless.path;
			networks = {
				"@home-uuid@" = {
					#psk = "A2C44EC1ECF3EEAA2471617E2EDC1F";
					psk = "@home-psk@";
				};
			};

			allowAuxiliaryImperativeNetworks = true;
			userControlled = {
				enable = true;
				group = "network";
			};
			extraConfig = ''
				update_config=1
			'';
		};
	};

	users.groups.network = {};

	systemd.services.wpa_supplicant.preStart = "touch /etc/wpa_supplicant.conf";
}
