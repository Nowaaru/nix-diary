{
  pkgs,
  lib,
  ...
}: {
  resizeImage = resize: imagePath:
    pkgs.stdenv.mkDerivation (finalAttrs: {
      pname = "resize-image-result";
      version = "1.0.0";

      unpackPhase = ''true'';

      src = with lib;
        (lib.evalModules {
          modules = with lib.types;
          with (import ./types.nix lib); [
            {
              options = {
                image = mkOption {
                  type = let
                    imageUnionType = oneOf [
                      (imageWithExt ".gif")
                      (imageWithExt ".png")
                      (imageWithExt ".jpg")
                      (imageWithExt ".jpeg")
                    ];
                  in
                    either imageUnionType (listOf imageUnionType);

                  description = "the image, or list of images to use for the theme";
                };
              };

              config.image = imagePath;
            }
          ];
        })
        .config
        .image;

      nativeBuildInputs = with pkgs; [
        imagemagick
      ];

      buildPhase = ''
        mkdir -p $out;
        magick $src -resize ${resize} $out/%d.png
      '';
    });

  gifToImages = {
    imagePath,
    resize ? "1280x720",
  } @ params:
    pkgs.stdenv.mkDerivation (finalAttrs: {
      pname = "gif-to-image-result";
      version = "1.0.0";

      unpackPhase = ''true'';

      src = with lib;
        (lib.evalModules {
          modules = with lib.types;
          with (import ./types.nix lib); [
            {
              options = {
                image = mkOption {
                  type = let
                    imageUnionType = oneOf [
                      (imageWithExt ".gif")
                      (imageWithExt ".png")
                      (imageWithExt ".jpg")
                      (imageWithExt ".jpeg")
                    ];
                  in
                    either imageUnionType (listOf imageUnionType);

                  description = "the image, or list of images to use for the theme";
                };
              };

              config.image = imagePath;
            }
          ];
        })
        .config
        .image;

      nativeBuildInputs = with pkgs; [
        imagemagick
      ];

      buildPhase = ''
        mkdir -p $out;
        magick $src -coalesce${
          if resize
          then " -resize ${resize} "
          else ""
        }$out/%d.png
      '';
    });
}
