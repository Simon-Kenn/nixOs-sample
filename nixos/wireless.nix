{
	networking = {
		wireless = {
			enable = true;
			networks = {
				"Bbox-5C32B2F3" = {
					psk = "A2C44EC1ECF3EEAA2471617E2EDC1F";
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
