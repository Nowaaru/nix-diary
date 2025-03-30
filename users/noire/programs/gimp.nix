{
  pkgs,
  inputs,
  withSystem,
  ...
}: {
  home.packages = with pkgs; [
    gimp
    # ((gimp.overrideAttrs
    #   (
    #     _: rec {
    #       version = "3.0.2";
    #
    #       patches = [
    #         (pkgs.replaceVars (inputs.self + /users/noire/patches/gimp/remove-cc-reference.patch) {
    #           cc_version = stdenv.cc.cc.name;
    #         })
    #
    #       ];
    #
    #       src = fetchurl {
    #         url = "http://download.gimp.org/pub/gimp/v${lib.versions.majorMinor version}/gimp-${version}.tar.xz";
    #         sha256 = "sha256-VG3cMMstDnkSPH/LTXghHh7npqrOkaagrYy8v26lcaI=";
    #       };
    #     }
    #   ))
    # .override {})
  ];
}
# }))

