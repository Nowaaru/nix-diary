{ pkgs, ... }:
let
	windowsFS = "Windows (C:)";
	miscellaneousFS = "Miscellaneous (D:)";
	devices = {
		nvme="/dev/nvme0n1p4";
		hdd="/dev/sdb3";
	};
in {
	fileSystems = {
		"${windowsFS}" = {
			label = windowsFS;
			device = devices.nvme;
			fsType = "ntfs";
			

			# If this is enabled, say goodbye
			# to Windows if something.. goes wrong.
			#
			# Please don't enable this.
			autoFormat = false;
			autoResize = false;
			mountPoint = "/mnt/windows";
		};
		"${miscellaneousFS}" = {
			label = miscellaneousFS;
			device = devices.hdd;
			fsType = "ntfs";

			depends = [
				"/mnt/windows"
			];
			
			# See above.
			autoFormat = false;
			autoResize = false;
			mountPoint = "/mnt/miscellaneous";
		};
	};
	
}
