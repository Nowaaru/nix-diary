{
  inputs,
  lib,
  pkgs,
  ...
}: let
  removeOverrides = k: builtins.removeAttrs k ["__functors" "override" "overrideDerivation" "__functionArgs"];
  clients = removeOverrides (builtins.mapAttrs (_: removeOverrides) inputs.nmm-mods.clients);
in {
  imports = [
    inputs.nix-mod-manager.homeManagerModules.default
  ];

  programs.nix-mod-manager = {
    enable = true;
    forceGnuUnzip = true;

    inherit clients;
  };

  home.file.nmm-ggst-module-extra-costumes-patch-config = {
    enable = true;
    force = true;
    text = lib.foldlAttrs (acc: k: v: acc + ''${k} = ${(
          if (builtins.typeOf v) == "bool"
          then lib.trivial.boolToString
          else builtins.toString
        )
        v}''\n'') "" {
      Enable_Console = true;
      File_Access_Logging = false;
      Loose_File_Loading = false;
      Costumes_Patch = true;
      Random_Costumes = false;
      Log_Script_Errors = true;
    };
    target = lib.strings.normalizePath "${clients.guilty-gear-strive.rootPath}/${clients.guilty-gear-strive.binaryPath}/plugins/config.toml";
  };
}
