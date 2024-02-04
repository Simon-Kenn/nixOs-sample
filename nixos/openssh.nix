{config, lib, ...}:let
	hasOptinPersistence = config.environment.persistence ?"/persist";
in {
	services.openssh = {
		enable = true;
		settings = {
			PasswordAuthentication = false;
			PermitRootLogin = "no";
		};

		hostKeys = [{
			path = "${lib.optionalString hasOptinPersistence "/persist"}/etc/ssh/ssh_host_ed25519_key";
			type = "ed25519";
		}];
	};
}
