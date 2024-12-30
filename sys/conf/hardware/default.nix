{
  lib,
  config,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./storage.nix
    ./nvidia.nix
    # ./amd.nix
  ];

  hardware = {
    # Hardware setup.
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;

    graphics = {
      enable = lib.mkDefault true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        intel-compute-runtime
      ];
    };

    # Enable OpenTabletDriver.
    opentabletdriver.enable = true;
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp7s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
