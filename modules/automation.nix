{ pkgs, inputs, ... }:
let
	python = pkgs.python3.withPackages (ps: [ ps.requests ]);

	johnny-six = pkgs.stdenvNoCC.mkDerivation {
		pname = "johnny-six";
		version = inputs.johnny-six.shortRev;

		src = inputs.johnny-six;

		dontBuild = true;

		installPhase = ''
			install -d $out
			install -m 0444 radio.liq wuvt.liq $out/
			install -m 0444 config_env.liq $out/config.liq
			install -m 0555 get_track.py check_auth.py $out/
		'';
	};
in
{
	services.liquidsoap.streams.johnny-six = "${johnny-six}/wuvt.liq";

	systemd.services.johnny-six = {
		wants = [ "network-online.target" ];
		path = [ python pkgs.curl ];
		environment.SCRIPT_PATH = "${johnny-six}";
	};
}
