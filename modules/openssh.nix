{
	services.openssh = {
		enable = true;

		settings = {
			PasswordAuthentication = false;
			KbdInteractiveAuthentication = false;
			PermitRootLogin = "no";
		};

		hostKeys = [{
			type = "ed25519";
			path = "/etc/ssh/ssh_host_ed25519_key";
		}];

		generateHostKeys = false;
	};
}
