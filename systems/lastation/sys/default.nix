/*
System preinitialization. Used to configure Nix itself.
*/
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

    # Peripheral things
    ./razer.nix

    # XDG
    ./xdg.nix

    # DNS
    ./dns.nix

    # Plex alternative
    ./jellyfin.nix

    ./deluge.nix
    ./gaming.nix
  ];

  nix = {
    package = pkgs.lix;

    optimise = {
      automatic = true;
      persistent = true;
    };

    settings = {
      experimental-features = ["nix-command" "flakes"];
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  # Dependencies and things.
  environment.systemPackages = with pkgs;
    [
      dotnet-runtime
      unrar # unzip replacement
      grc # generic colourizer
      fzf # fuzzy find
      wget2 # oh yeah
    ]
    ++ [home-manager]; # do not remove home-manager.
}
