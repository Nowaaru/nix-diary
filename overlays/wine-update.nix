withSystem: {
  home-manager,
  self,
  ...
} @ inputs: (_: super: let
  version = "10.2";
in {
  wineWowPackages.full =
    (super.wineWowPackages.full.override rec {
      })
    .overrideAttrs (a:
      a
      // {
        inherit version;

        src = builtins.fetchurl {
          url = "https://dl.winehq.org/wine/source/10.x/wine-${version}.tar.xz"; #
          sha256 = "sha256:0gr40jnv4wz23cgvk21axb9k0irbf5kh17vqnjki1f0hryvdz44x";
        };
      });
})
