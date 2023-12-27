{ ... }:
let
	windowsFS = "Windows (C:)";
	miscellaneousFS = "Miscellaneous (D:)";
	devices = {
		nvme="/dev/nvme0n1p4";
		hdd="/dev/sda3";
	};
  options = [
        "UUID=84D6B99BD6B98E44"
        "uid=1000"
        "gid=100"
        "rw"
        "user"
        "exec"
        "umask=000"
  ];
in {
	fileSystems = {
		"${windowsFS}" = {
      inherit options;
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
      inherit options;
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
