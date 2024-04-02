{
  stdenv,
  pkgs,
  ...
}: let
  selfTrace = w: builtins.trace w w;
in {
  home.file = {
    ".config/vinegar/config.toml".text = ''
      [env]
      WINEESYNC = "0"
      [splash]
      enabled = false
      [player]
      renderer = "Vulkan"
      dxvk = false
      [studio]
      dxvk = false
      renderer = "Vulkan"
    '';
  };

  /*nixpkgs.overlays = [
    (final: prev: {
      vinegar = prev.vinegar.overrideAttrs (old:
        with lib.lists; rec {
          version = "1.7.3";
          src = prev.fetchFromGitHub {
            owner = "vinegarhq";
            repo = "vinegar";
            rev = "v${version}";
            hash = "sha256-aKL+4jw/uMbbvLRCBHstCTrcQ1PTYSCwMNgXTvSvMeY=";
          };
          buildInputs = forEach (old.buildInputs) (
            idx:
              if (lib.strings.hasInfix "wine" idx.pname)
              then
                prev.wineWowPackages.stagingFull.overrideDerivation (oldAttrs: {
                  patches =
                     (oldAttrs.patches or []) ++  [
                      # (pkgs.fetchurl {
                      #   name = "vinegar-wine-segrevert.patch";
                      #   url = "https://raw.githubusercontent.com/flathub/org.vinegarhq.Vinegar/e24cb9dfa996bcfeaa46504c0375660fe271148d/patches/wine/segregrevert.patch";
                      #   hash = "sha256-MzX17s8GtdeHqg+WsfDEQn1A0XeBTEwQf/WilUxkkTU=";
                      # })
                    ];
                })
              else idx
          );
        });
    })
  ];*/

  home.packages = with pkgs; [
    rojo
  ];
}
