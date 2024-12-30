{
  config,
  lib,
  ...
}: {
  hardware.nvidia = {
    modesetting.enable = true; # required
    powerManagement.enable = true; # can cause sleep problems but supposedly fixed with the newest nvidia update
    powerManagement.finegrained = false; # turns off gpu when nothing is using the nvidia graphics stack (pretty cool!!!)

    open = lib.mkForce false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  boot = {
    # boot nvidia second
    initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_drm"
      "nvidia_uvm"
    ];

    kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
      "nvidia.NVreg_EnableGpuFirmware=1"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];

    # blacklistedKernelModules = ["nouveau"];
  };

  services.xserver = {
    # Enable the X11 windowing system.
    videoDrivers = ["nvidia"];
  };
}
