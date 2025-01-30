{
  pkgs,
  lib,
  ...
}: {
  boot = {
    initrd.kernelModules = [
      "amdgpu"
    ];

    kernelParams = [
      "amdgpu.ppfeaturemask=0xffffffff"
      # "video=DP-1:1920x1080@165"
      # "video=DP-2:1920x1080@60"
    ];
  };

  environment.variables.AMD_VULKAN_ICD = "RADV";

  services.xserver = {
    # Enable the X11 windowing system.
    videoDrivers = ["amdgpu"];
  };
}
