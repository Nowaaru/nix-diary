{fetchurl, fetchpatch}:
self: super:
{  # wine-staging doesn't support overrideAttrs for now
  super.wine = <nixpkgs>.wineWowPackages.stagingFull.overrideDerivation (oldAttrs: {
    src = fetchurl {
      url = "https://dl.winehq.org/wine/source/9.0/wine-9.0-rc4.tar.xz"; #
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };
    patches =
      (oldAttrs.patches or [ ])
      ++ [
        # upstream issue: https://bugs.winehq.org/show_bug.cgi?id=55604
        # Here are the currently applied patches for Roblox to run under WINE:
        fetchpatch {
          name = "vinegar-wine-segrevert.patch";
          url = "https://raw.githubusercontent.com/flathub/org.vinegarhq.Vinegar/8fc153c492542a522d6cc2dff7d1af0e030a529a/patches/wine/temp.patch";
          hash = "sha256-AnEBBhB8leKP0xCSr6UsQK7CN0NDbwqhe326tJ9dDjc=";
        }
      ];
  });
}

