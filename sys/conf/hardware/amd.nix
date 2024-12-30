{pkgs, ...}: {
  boot = {
    initrd.kernelModules = [
      "amdgpu"
    ];

    kernelParams = [
      "amdgpu.ppfeaturemask=0xffffffff"
    ];
  };

  hardware.opengl = with pkgs; {
    extraPackages = [amdvlk];
    extraPackages32 = [driversi686Linux.amdvlk];
  };

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    videoDrivers = ["amdgpu"];
  };
}
