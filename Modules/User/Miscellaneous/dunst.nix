{
  pkgs,
  nix-colors,
  inputs,
  ...
}: let
  inherit (inputs) self;
  inherit (import "${self}/Config/Hyprland" {inherit pkgs nix-colors;}) theme;
  # dunstThemeSettings = pkgs.lib.attrsets.attrByPath ["programs" "dunst"] defaultDunstTheme theme;
  defaultDunstTheme = {
    global = {
      width = 300;
      height = 300;
      offset = "30x50";
      origin = "top-right";
      transparency = 10;
      frame_color = "#eceff1";
      font = "JetBrains Mono NF 8";

      gap_size = 4;
    };

    urgency_low = {
      background = "#${theme.colors.base01}"; # "#37474f";
      frame_color = "#${theme.colors.base02}44"; # "#eceff1";
      foreground = "#${theme.colors.base07}"; # "#eceff1";
      timeout = 2;
    };

    urgency_normal = {
      background = "#${theme.colors.base0D}"; # "#37474f";
      frame_color = "#${theme.colors.base0B}44"; # "#eceff1";
      foreground = "#${theme.colors.base07}"; # "#eceff1";
      timeout = 5;
    };

    urgency_critical = {
      set_transient = true;
      background = "#${theme.colors.base0F}"; # "#37474f";
      frame_color = "#${theme.colors.base0F}22"; # "#eceff1";
      foreground = "#${theme.colors.base02}"; # "#eceff1";
      timeout = 10;
    };
  };
in {
  services.dunst = {
    enable = true;
    settings = defaultDunstTheme;
  };
}
