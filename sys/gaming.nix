{
  programs = {
    gamemode = {
      enable = true;
    };

    steam = {
      enable = true; # steam-input works through programs.steam rather than just the package

      gamescopeSession = {
        enable = true;
      };

      protontricks.enable = true;
      remotePlay.openFirewall = true;
      extest.enable = true;
    };
  };
}
