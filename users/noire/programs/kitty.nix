{
  stable,
  configure,
  lib,
  ...
}@args:
/*
* flexico
* hardcore
* hybrid
* japanesque
* kangawabones
* purpurite
*/
{
  programs.kitty =
    stable.lib.mkForce ((configure "kitty")
    // {
      enable = true;
      package = stable.kitty;
    });
}
