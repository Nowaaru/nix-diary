{pkgs, ...}: {
  imports = [
    # Directory initializers.
    ./Shell/init.nix
    ./Git/init.nix

    # WINE: WINE Is Now an Emulator.
    ./Utility/Wine/init.nix

    # Build utilities.
    ./Utility/build.nix

    # Don't ever use this.
    ./Utility/electron.nix

    # Kitty terminal.
    ./Utility/kitty.nix

    # Various performance metrics.
    ./Utility/status.nix
    ./loopback.nix

    # Stuff.
    ./firefox.nix
    ./storage.nix
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
