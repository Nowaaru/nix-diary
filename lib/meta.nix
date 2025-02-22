{
  lib,
  pkgs,
  ...
}: {
  mkIfElse = with lib;
    predicate: yes: no:
      mkMerge [
        (mkIf predicate yes)
        (mkIf (!predicate) no)
      ];

  selfTrace = this: builtins.trace this this;

  mkPlymouthTheme = {
    name ? "plymouth-theme",
    description ? "A cool Plymouth theme.",
    comment ? "Welcome to Gamindustri!",
    image ? null,
    resolution ? null,
    framerate ? 50,
  }@params:
    with lib; let
      themeOptions =
        (evalModules {
          modules = with types;
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

                comment = mkOption {
                  type = strMatching ".*";
                  description = "The author comment for the theme.";
                };

                description = mkOption {
                  type = strMatching ".*";
                  description = "The author description for the theme.";
                };

                framerate = mkOption {
                  type = ints.between 0 50;
                  description = "The author description for the theme.";
                };
              };

              config = {
                inherit comment description framerate;
                image = let
                  imgLib = import ./images.nix {
                    inherit pkgs lib;
                  };

                  
                  inherit (imgLib.${if (lib.strings.hasSuffix ".gif" image) then "gifToImages" else "resizeImage"} resolution image) outPath;
                in
                  builtins.map (x: "${outPath}/${x}") (builtins.attrNames (
                    builtins.readDir outPath
                  ));
              };
            }
          ];
        })
        .config;
    in
      pkgs.stdenv.mkDerivation (finalAttrs: {
        pname = name;
        version = "1.0.0";

        phases = ["buildPhase" "configurePhase" "fixupPhase"];

        # FIXME: if i do not figure out why this does piece of
        # retard shit is building to /build/ instead of $out
        # i am going to have the greatest crashout ever perceived
        # by another human mark my fucking words
        buildPhase = ''
          # echo "out: $out, out-dir: $OUT_DIR, src: $src, img-dir: $IMG_DIR";
          export OUT_DIR=$out/share/plymouth/themes/${name}
          export SCRIPT=$OUT_DIR/${name}.script
          export IMG0=${(lib.traceVal (builtins.elemAt themeOptions.image 0))}
          export IMG_DIR=$(dirname $(realpath $IMG0))

          mkdir -pv $OUT_DIR
          cp $src/template/template.script $OUT_DIR/${name}.script
          ln -sv $IMG_DIR $OUT_DIR/images;

          sed -i -re "s!progress\\-!!gm" $SCRIPT;
          sed -i -re "s!SPEED!${builtins.toString (themeOptions.framerate / 50)}!gm" $SCRIPT;
          sed -i -re "s!NUM!${builtins.toString ((builtins.length themeOptions.image)/*  - 1 */)}!gm" $SCRIPT;
        '';

        configurePhase = ''
          # have template first to get all names out of the way
          cat > $OUT_DIR/${name}.plymouth << EOF
          [Plymouth Theme]
          Name=${name}
          Description=${themeOptions.description}
          Comment=${themeOptions.comment}
          ModuleName=script

          [script]
          ImageDir=$OUT_DIR/images
          ScriptFile=$SCRIPT
          EOF
        '';

        src = builtins.fetchGit {
          url = "git@github.com:adi1090x/plymouth-themes.git";
          rev = "5d8817458d764bff4ff9daae94cf1bbaabf16ede";
        };

        meta = {
          license = lib.licenses.gpl3Only;
        };
      });

  mkModules = dir:
    lib.attrsets.foldlAttrs (
      acc: filename: _type: acc ++ ["${dir}/${filename}"]
    ) []
    (builtins.readDir dir);

  withInputs = this: with_inputs: let
    imported =
      if (builtins.elem (builtins.typeOf this) ["path" "string"])
      then import this
      else this;
    is_attrset = builtins.isAttrs imported;
    parameters = builtins.functionArgs imported;
    unfillableParameters = builtins.attrNames (lib.attrsets.filterAttrs (k: v: !v && this ? k)) parameters;
    amtUnfillable = builtins.length unfillableParameters;
  in
    if is_attrset
    then imported
    else
      (
        if
          (lib.asserts.assertMsg (builtins.isFunction imported
            || (lib.asserts.assertMsg (
                amtUnfillable
                == 0
              ) "parameters ${lib.lists.imap0 (k: v: "${
                  if (k - 1 == amtUnfillable)
                  then "'${v},' and"
                  else
                    (
                      if (k == amtUnfillable)
                      then "'${v}'"
                      else "'${v}',"
                    )
                }")
                unfillableParameters} do not have defaults and are not filled in by parameter 'args'") {})
          "input function is not of type function (got ${builtins.typeOf this})")
        then (import this (lib.attrsets.filterAttrs (k: _: (builtins.elem k (builtins.attrNames parameters))) with_inputs))
        else {}
      );
}
