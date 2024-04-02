# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  home.packages = [
    grc
    fzf
    zip
    unzip

    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fishPlugins.grc
  ];

  imports = [
    # include NixOS-WSL modules
    inputs.nixos-wsl.nixosModules.default
    ./init.nix
    ./hardware.nix
  ];

  wsl = {
    enable = true;
    defaultUser = mkForce "vert";
    useWindowsDriver = true;
    startMenuLaunchers = true;

    interop.register = true;

    wslConf = {
      network.hostname = "leanbox";
      user.default = mkDefault "noire";
    };
  };

  services = {
    openssh.enable = true;
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  time.hardwareClockInLocalTime = false;
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
