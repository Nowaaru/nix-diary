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
      "video=DP-1:1920x1080@165"
      "video=DP-2:1920x1080@60"
    ];
  };

  environment.variables.AMD_VULKAN_ICD = "RADV";

  chaotic.mesa-git = {
    enable = true;
    extraPackages = with pkgs; [
      amdvlk
    ];

    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };

  hardware.graphics = {
    package = pkgs.mesa_git.drivers;
    package32 = pkgs.mesa32_git.drivers;
  };

  services.xserver = {
    # Enable the X11 windowing system.
    videoDrivers = ["amdgpu"];
  };
}
