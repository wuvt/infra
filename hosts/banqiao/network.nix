{
	networking = {
		hostName = "banqiao";
		useDHCP = false;
		interfaces.eno1.ipv4.addresses = [{
			address = "192.168.0.66";
			prefixLength = 24;
		}];
		defaultGateway = "192.168.0.1";
		nameservers = [ "192.168.0.1" ];

		firewall.enable = true;
	};
}
