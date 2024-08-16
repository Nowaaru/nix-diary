{...}: let
  windowsFS = "Windows (C:)";
  miscellaneousFS = "Miscellaneous (D:)";

  devices = {
    ssd = "/dev/disk/by-uuid/0E2058022057EF69";
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
  };
}
