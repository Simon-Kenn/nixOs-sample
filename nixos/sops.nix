{inputs, config, ...}: let
	isEd25519 = k: k.type == "ed25519";
	getKeyPath = k: k.path;
	keys = builtins.filter isEd25519 config.services.openssh.hostKeys;
in {
	imports = [ inputs.sops-nix.nixosModules.sops ];

	sops = {
		defaultSopsFile = ../secrets/secrets.yaml;
		age.sshKeyPaths = map getKeyPath keys;
		#secrets.user-password = {};
		#secrets.wifi-psk = {};
		#age.generateKey = true;
	};
}
