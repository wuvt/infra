{
	hardware.enableAllHardware = true;

	fileSystems = {
		"/" = {
			device = "/dev/disk/by-label/nixos";
			fsType = "ext4";
		};
		"/boot" = {
			device = "/dev/disk/by-label/BOOT";
			fsType = "vfat";
			options = [ "umask=0077" ];
		};
	};

	swapDevices = [{
		device = "/var/lib/swapfile";
		size = 8 * 1024; #MiB
	}];

	boot.loader = {
		grub = {
			enable = true;
			efiSupport = true;
			device = "nodev";
		};
		efi.canTouchEfiVariables = true;
	};
}
