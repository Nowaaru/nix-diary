{ pkgs, inputs, ... }: {
  programs = {
    # gpu-screen-recorder = {
    #   enable = true;
    #   package = pkgs.callPackage (inputs.self + /modules/gpu-screen-recorder/packages/gpu-screen-recorder.nix) pkgs.xorg;
    #   ui = {
    #     enable = true;
    #     autostart.enable = true;
    #     keymaps.register = true;
    #   };
    #   notify.enable = true;
    # };

    gamemode = {
      enable = true;
    };

    steam = {
      enable = true; # steam-input works through programs.steam rather than just the package
      extraCompatPackages = with pkgs; [
        proton-ge-bin
        steam-play-none
      ];

      gamescopeSession = {
        enable = true;
      };

      protontricks.enable = true;
      remotePlay.openFirewall = true;
      extest.enable = true;
    };
  };
}
