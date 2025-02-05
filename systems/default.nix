args @ {
  importApply,
  lib,
  ...
}: let
  systems = lib.attrsets.foldlAttrs (a: k: v:
    a
    ++ [
      {
        imports = [
          (
            if v == "directory"
            then importApply ./${k}/default.nix args
            else importApply ./${k} args
          )
        ];
      }
    ]) [] (lib.attrsets.filterAttrs (k: _: k != "default.nix") (builtins.readDir ./.));
in {
  imports = systems;
}
# default = { pkgs, ... }: {
#     imports = [ ./nixos-module.nix ];
#     services.foo.package = withSystem pkgs.stdenv.hostPlatform.system ({ config, ... }:
#       config.packages.default
#     );
#   };

