withSystem: {
  rust-overlay,
  nix-mod-manager,
  home-manager,
  hyprpicker,
  nurpkgs,
  nixgl,
  ...
} @ inputs: let
  # TODO: recursively call these with withSystem and inputs
  unwrap-overlay = overlay_path_or_overlay:
    if builtins.isPath overlay_path_or_overlay
    then builtins.trace "recursing with array args" (unwrap-overlay (import overlay_path_or_overlay))
    else
      (let
        overlay = overlay_path_or_overlay;
      in
        if
          builtins.isFunction overlay
          && builtins.length (builtins.attrValues (builtins.functionArgs overlay)) == 0
        then builtins.trace "unwrapping withsystem ${overlay_path_or_overlay}" (unwrap-overlay overlay withSystem)
        else
          (
            if builtins.isFunction overlay
            then builtins.trace "function named" (overlay inputs)
            else builtins.trace "using default return" overlay
          ));
in [
  rust-overlay.overlays.default
  hyprpicker.overlays.default
  nurpkgs.overlays.default
  nixgl.overlay

  (import ./node-neovim.nix withSystem inputs)
  (import ./stable-basedpyright.nix withSystem inputs)
  (import ./wine-update.nix withSystem inputs)
  (import ./extend-lib.nix withSystem inputs)
  (import ./fix-kdepackages-nondeterminism.nix withSystem inputs)
  # (import ./wayland-protocol-1-43.nix withSystem inputs)
]
/*
(_: super: {
  inherit
    ((import nixpkgs-mongodb-pin {
      inherit system;
      config.allowUnfreePredicate = pkg: "mongodb" == (super.lib.getName pkg);
    }))
    mongodb
    ;
})
*/

