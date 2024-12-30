{inputs, ...}: let
  removeOverrides = k: builtins.removeAttrs k ["__functors" "override" "overrideDerivation" "__functionArgs"];
in {
  imports = [inputs.nix-mod-manager.homeManagerModules.default];
  programs.nix-mod-manager = {
    enable = true;
    forceGnuUnzip = true;

    clients = removeOverrides (builtins.mapAttrs (_: removeOverrides) inputs.nmm-mods.clients);
  };
}
