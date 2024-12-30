{
  config,
  lib,
  ...
}: {
  hardware.nvidia = {
    modesetting.enable = true; # required
    powerManagement.enable = true; # can cause sleep problems but supposedly fixed with the newest nvidia update
    powerManagement.finegrained = true; # turns off gpu when nothing is using the nvidia graphics stack (pretty cool!!!)

    prime = {
      sync.enable = true;

      nvidiaBusId = "PCI:9:0.0"; # pci@0000:09:00.0
      amdBusId = "PCI:6:0.0"; # pci@0000:06:00.0
    };

    open = lib.mkForce false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  boot = {
    # boot nvidia second
    # initrd.kernelModules = [
    #   "nvidia"
    # ];

    kernelModules = [
      "nvidia"
    ];

    kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
      "nvidia.NVreg_EnableGpuFirmware=0"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];

    blacklistedKernelModules = ["nouveau"];
  };

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    videoDrivers = ["nvidia"];
  };
}
