# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{lib, ...}: {
  imports = [];

  boot = {
    initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
    initrd.kernelModules = [];
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];
  };

  fileSystems = {
    "/mnt/wsl".device = "none";
    "/mnt/wsl".fsType = "tmpfs";

    "/usr/lib/wsl/drivers" = {
      device = "none";
      fsType = "9p";
    };

    "/lib/modules" = {
      device = "none";
      fsType = "tmpfs";
    };

    "/lib/modules/5.15.146.1-microsoft-standard-WSL2" = {
      device = "none";
      fsType = "overlay";
    };

    "/" = {
      device = "/dev/disk/by-uuid/4cd444f0-461f-4c5b-8422-282d0605d24c";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/A644-2DDD";
      fsType = "vfat";
    };

    "/mnt/wslg/distro" = {
      device = "none";
      fsType = "none";
      options = ["bind"];
    };

    "/usr/lib/wsl/lib" = {
      device = "none";
      fsType = "overlay";
    };

    "/tmp/.X11-unix" = {
      device = "/mnt/wslg/.X11-unix";
      fsType = "none";
      options = ["bind"];
    };

    "/mnt/wslg/doc" = {
      device = "none";
      fsType = "overlay";
    };

    "/mnt/c" = {
      device = "C:\134";
      fsType = "9p";
    };

    "/mnt/d" = {
      device = "D:\134";
      fsType = "9p";
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/91e9f923-14db-4957-8801-91a42ae712ec";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eth0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
