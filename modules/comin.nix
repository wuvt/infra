{ inputs, ... }:
{
	imports = [ inputs.comin.nixosModules.comin ];

	services.comin = {
		enable = true;

		remotes = [{
			name = "origin";
			url = "https://github.com/wuvt/infra";
			branches.main.name = "master";
			poller.period = 60;
		}];
	};
}
