{inputs, ...}:
{
	imports = [ inputs.sops-nix.nixosModules.sops ];

	sops = {
		defaultSopsFile = ../secrets/secrets.yaml;
		age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
		sops.secrets.user-password = {};
		sops.secrets.wifi-psk = {};
		#age.generateKey = true;
	};
}
