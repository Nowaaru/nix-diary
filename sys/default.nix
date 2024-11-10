{pkgs, ...}: {
  imports = [
    # Directory initializers.
    ./git

    # WINE: WINE Is Now an Emulator.
    ./util/wine

    # Build utilities.
    ./util/build.nix

    # Kitty terminal.
    ./util/kitty.nix

    # Various performance metrics.
    ./util/status.nix

    # Makes the system work.
    ./input.nix
    ./shell.nix
    ./sound.nix
    ./storage.nix
  ];

  # Dependencies and things.
  environment.systemPackages = with pkgs;
    [
      dotnet-runtime
      unrar # unzip replacement
      grc # generic colourizer
      fzf # fuzzy find
    ]
    ++ [home-manager]; # do not remove home-manager.

  programs.steam.enable = true; # steam-input works through programs.steam rather than just the package
  programs.steam.gamescopeSession.enable = true;
}
