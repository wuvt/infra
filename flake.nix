{
	description = "WUVT infrastructure";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

		agenix.url = "github:ryantm/agenix";
		agenix.inputs.nixpkgs.follows = "nixpkgs";

		comin.url = "github:nlewo/comin";
		comin.inputs.nixpkgs.follows = "nixpkgs";

		johnny-six.url = "github:wuvt/johnny-six";
		johnny-six.flake = false;
	};

	outputs = inputs @ { self, nixpkgs, agenix, ... }:
	let
		system = "x86_64-linux";
		pkgs = import nixpkgs { inherit system; };
	in
	{
		nixosConfigurations =
			nixpkgs.lib.genAttrs (builtins.attrNames (builtins.readDir ./hosts)) (
				name:
				nixpkgs.lib.nixosSystem {
					specialArgs = { inherit inputs; };
					modules = [ ./hosts/${name} { nixpkgs.pkgs = pkgs; } ];
				}
			)
			// {
				iso = nixpkgs.lib.nixosSystem {
					specialArgs = { inherit inputs; };
					modules = [ ./image { nixpkgs.pkgs = pkgs; } ];
				};
			};

		packages.${system} = {
			default = self.packages.${system}.iso;

			iso = self.nixosConfigurations.iso.config.system.build.isoImage;

			tools = pkgs.buildEnv {
				name = "wuvt-infra-tools";
				paths = [
					agenix.packages.${system}.default
					pkgs.age
					pkgs.age-plugin-fido2-hmac
					pkgs.mkpasswd
					pkgs.openssh
				];
			};
		};

		devShells.${system}.default = pkgs.mkShellNoCC {
			packages = [ self.packages.${system}.tools ];
		};
	};
}
