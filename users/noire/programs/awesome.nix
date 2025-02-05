{ pkgs, root, ... }:
{
  xsession.windowManager.awesome = {
    enable = true;
    noArgb = false;
    luaModules = with pkgs.luaPackages; [
      luarocks
      luadbi-mysql
    ];
  };

  home.file = {
    ".config/awesome/rc.lua" = {
      enable = true;
      source = root + /cfg/awesome.lua;
      target = ".config/awesome/rc.lua";
    };
  };
}
