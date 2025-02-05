{lib, ...}: let
  windowsFS = "Windows (C:)";

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

    {device = "/dev/disk/by-uuid/7304f85c-848d-4ff2-a054-bd572fb4d8d0";}
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/6f07d7da-21a7-4c5c-9036-8882fe094415";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/A644-2DDD";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };
}
