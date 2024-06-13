{
  pkgs,
  configure,
  ...
}:
/*
* flexico
* hardcore
* hybrid
* japanesque
* kangawabones
* purpurite
*/
{
  home.packages = with pkgs; [
    kitty-themes
    kitty
  ];

  programs.kitty =
    (configure "kitty")
    // {
      enable = true;
    };
}
