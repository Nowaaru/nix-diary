{
  pkgs,
  lib,
  ...
}: {
  xdg.desktopEntries = let
    gecko = lib.gamindustri.gecko.withGecko pkgs.floorp;
  in {
    # TODO: somehow stop the default profile from changing all the time
    floorp-noire = gecko.mkProfile {
      profile = "noire";
    };
    floorp-test2 = gecko.mkProfile {
      profile = "the smelly ward";
    };
    floorp-test3 = gecko.mkProfile { 
      profile = "lego gotham city";
    };
  };

  home.packages = with pkgs; [
    floorp
  ];
}
