{ lib, pkgs, ... }:
{
	nix = {
		settings.experimental-features = [
			"nix-command"
			"flakes"
		];

		gc = {
			automatic = true;
			dates = "weekly";
			options = "--delete-older-than 30d";
		};
	};

	system.stateVersion = "26.05";

	time.timeZone = "America/New_York";
	i18n.defaultLocale = "en_US.UTF-8";

	environment.systemPackages = with pkgs; [
		git
		htop
		tmux
		vim
	];
}
