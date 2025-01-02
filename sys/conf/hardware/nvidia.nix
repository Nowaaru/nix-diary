{
  config,
  lib,
  ...
}: {
  hardware.nvidia = {
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:9:0:0";
    };

    modesetting.enable = lib.mkDefault true; # required
    powerManagement.enable = true; # can cause sleep problems but supposedly fixed with the newest nvidia update

    open = lib.mkDefault false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  boot = {
    # boot nvidia second
    kernelModules = [
      "nvidia"
      # "nvidia_modeset"
      # "nvidia_drm"
      # "nvidia_uvm"
    ];

    kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
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
