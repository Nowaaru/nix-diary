{pkgs, ...}: {
  imports = [
    # Directory initializers.
    ./shell
    ./git

    # WINE: WINE Is Now an Emulator.
    ./util/wine

    # Build utilities.
    ./util/build.nix

    # Don't ever use this.
    ./util/electron.nix

    # Kitty terminal.
    ./util/kitty.nix

    # Various performance metrics.
    ./util/status.nix

    # Stuff.
    ./firefox.nix
    ./storage.nix
    ./qemu.nix
  ];

  # Dependencies and things.
  environment.systemPackages = with pkgs;
    [
      libsForQt5.kio-admin
      dotnet-runtime
      grc
      fzf
      zip
      unzip
    ]
    ++ [home-manager]; # do not remove home-manager.
}
