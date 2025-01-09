{
  config,
  lib,
  ...
}: {
  hardware.nvidia = {
    prime = {
      allowExternalGpu = true;

      reverseSync = {
        enable = false;
        setupCommands.enable = false;
      };

      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:9:0:0";
    };

    modesetting.enable = lib.mkForce true; # required
    powerManagement.enable = true; # can cause sleep problems but supposedly fixed with the newest nvidia update
    powerManagement.finegrained = false;

    open = lib.mkDefault true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    nvidiaSettings = false;
  };

  boot = {
    # boot nvidia second
    initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_drm"
    ];

    kernelParams = [
      "nvidia.NVreg_EnableGpuFirmware=1"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];

    blacklistedKernelModules = ["nouveau"];
  };

  services.xserver = {
    # Enable the X11 windowing system.
    videoDrivers = ["nvidia"];
  };
}
