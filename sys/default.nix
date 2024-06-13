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
    ./mpd.nix
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

  programs.steam.enable = true; # steam-input works through programs.steam rather than just the package
  programs.steam.gamescopeSession.enable = true;
}
