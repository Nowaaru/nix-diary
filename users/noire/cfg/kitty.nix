{ pkgs, lib }: 
let
  fontName = "VictorMonoNFM-Semibold";
in 
{
  themeFile = "kanagawabones";
  shellIntegration.enableFishIntegration = true;

  settings = {
    disable_ligatures = "cursor";
    font_family = lib.mkDefault fontName;
    font_features = "${ fontName } +liga";

    # this is really annoying
    confirm_os_window_close = 0;

    # cursor_trail_decay = "[0.1 0.4]";
    cursor_trail_start_threshold = 2;
    cursor_trail = 0;

    strip_trailing_spaces = "smart";

    # Repaint delay in MS, 10 = 10ms per frame = 100fps
    # 6ms = 165fps
    repaint_delay = 6;
    # flickering is not a problem anymore whooo!
    sync_to_monitor = "no";

    bell_path = "none";
  };

  font = {
    name = lib.mkForce fontName;
    package = lib.mkForce pkgs.nerd-fonts.victor-mono; # (pkgs.nerdfonts.override {fonts = [ fontName ];});
  };
}

