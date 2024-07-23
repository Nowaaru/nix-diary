{ pkgs, inputs, ... }:
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
      source = ../cfg/awesome.lua;
      target = ".config/awesome/rc.lua";
    };
  };
}
