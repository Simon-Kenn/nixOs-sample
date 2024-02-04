{config, ...}: {
	sops.secrets."wireless.env".neededForUsers = true;
	#sops.secrets."wireless.env" = {};
	networking = {
		wireless = {
			enable = true;
			environmentFile = config.sops.secrets."wireless.env".path;
			networks = {
				#"Bbox-5C32B2F3" = {
				#	psk = "A2C44EC1ECF3EEAA2471617E2EDC1F";
				#};
				"@HOME@" = {
					psk = "@home@";
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
