{
	home.sessionsVariables = {
		GPG_TTY = "$(tty)";
	};

	services.gpg-agent = {
		enable = true;
		pinentryFlavor = "curses";
	};

	programs = {
		gpg = {
			enable = true;
			publicKeys = [{
				source = ./pgp.asc;
				trust = 5;	
			}];
		};
	};
}
