{ config, ... }:
{
	imports = [
		../../modules/base.nix
		../../modules/disks.nix
		../../modules/comin.nix
		../../modules/openssh.nix
		../../modules/users.nix
		../../modules/hostkey.nix
		../../modules/automation.nix

		./network.nix
	];

	age.secrets.am-trackman-password.file = ../../secrets/am-trackman-password.age;

	systemd.services.johnny-six = {
		environment = {
			ALSA_OUTPUT = "plughw:CARD=ICUSBAUDIO7D,DEV=0";
			BASE_PATH = "http://titanic.wuvt.vt.edu/automation";
			TRACKMAN_URL = "https://trackman-am.apps.wuvt.vt.edu/api/automation/log";
			PLAYLIST_API_URL = "";
		};

		serviceConfig.EnvironmentFile = config.age.secrets.am-trackman-password.path;
	};
}
