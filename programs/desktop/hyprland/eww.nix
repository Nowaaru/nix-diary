{
  configure,
  ...
}: let
  hypr-config = configure "hyprland";
in {
  programs.eww = {
    enable = true;
    configDir = hypr-config.theme.widgets;
  };
  # home.file = {
  #   ".config/eww" = {
  #     enable = lib.attrsets.hasAttrByPath ["theme" "widgets"] hypr-config;
  #     source = hypr-config.theme.widgets;
  #     recursive = lib.mkForce true;
  #   };
  # };
}
