{...}: let
  windowsFS = "Windows (C:)";
  miscellaneousFS = "Miscellaneous (D:)";
  globalFS = "Global (G:)";

  devices = {
    ssd = "/dev/disk/by-uuid/0E2058022057EF69";
    hdd = "/dev/disk/by-uuid/84D6B99BD6B98E44";
    global = "/dev/disk/by-label/Global";
  };

  options = [
    "uid=1000"
    "gid=100"
    "umask=000"
    "exec"
    "rw"
  ];
in {
  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];

  fileSystems = {
    "${windowsFS}" = {
      inherit options;
      label = windowsFS;
      device = devices.ssd;
      fsType = "ntfs";

      # If this is enabled, say goodbye
      # to Windows if something.. goes wrong.
      #
      # Please don't enable this.
      autoFormat = false;
      autoResize = false;
      mountPoint = "/mnt/windows";
    };

    "${globalFS}" = {
      inherit options;
      label = globalFS;
      device = devices.global;
      fsType = "exfat";

      # See above.
      autoFormat = false;
      autoResize = false;
      mountPoint = "/mnt/global";
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
