{ lib, modulesPath, pkgs, inputs, ... }:
{
	imports = [
		../modules/base.nix
		"${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
	];

	networking.hostName = "iso";

	isoImage = {
		edition = "wuvt-infra";
		contents = [{
			source = lib.sourceByRegex inputs.self [
				"^README\\.md$"
				"^secrets$"
				"^secrets/iso-id\\.age$"
			];
			target = "/infra";
		}];
	};

	users.users.nixos.enable = false;
	services.getty.autologinUser = lib.mkForce null;

	services.getty.helpLine = lib.mkForce ''
		WUVT infra live image.
		Log in as root.
		Read /iso/infra/README.md.
		iso-id at /iso/infra/secrets/iso-id.age.
	'';

	environment.systemPackages = [
		pkgs.age
		pkgs.age-plugin-fido2-hmac
	];

	system.stateVersion = "26.05";
}
