{ config, inputs, pkgs, ... }:
{
	imports = [ inputs.agenix.nixosModules.default ];

	system.activationScripts = {
		hostKey = {
			deps = [ "specialfs" ];
			text = ''
				key=/etc/ssh/ssh_host_ed25519_key
				if [ ! -s /etc/ssh/ssh_host_ed25519_key ]; then
					install -d -m 0755 /etc/ssh
					(umask 077 && ${pkgs.age}/bin/age --decrypt -i /etc/iso-id -o "$key.new" ${../hosts + "/${config.networking.hostName}/keys/ssh_host_ed25519_key.age"}) \
						&& mv "$key.new" "$key" \
						&& shred -fu /etc/iso-id
					rm -f "$key.new"
				fi
			'';
		};
		agenixInstall.deps = [ "hostKey" ];
	};

	age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
}
