{
  programs = {
    gpu-screen-recorder = {
      enable = true;
      ui = {
        enable = true;
        autostart.enable = true;
        keymaps.register = true;
      };
      notify.enable = true;
    };

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
