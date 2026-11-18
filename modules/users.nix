{ config, inputs, ... }:
{
	imports = [ inputs.agenix.nixosModules.default ];

	age.secrets.ladmin-password.file = ../secrets/ladmin-password.age;

	users = {
		mutableUsers = false;
		
		users.ladmin = {
			isNormalUser = true;
			description = "Local Administrator";
			uid = 1000;
			extraGroups = [ "wheel" ];
			hashedPasswordFile = config.age.secrets.ladmin-password.path;
			openssh.authorizedKeys.keyFiles = [ ../keys/ladmin.authorized_keys ];
		};
	};
}
