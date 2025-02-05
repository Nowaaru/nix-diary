withSystem: {
  rust-overlay,
  nix-mod-manager,
  home-manager,
  hyprpicker,
  nurpkgs,
  nixgl,
  ...
} @ inputs: [
  rust-overlay.overlays.default
  hyprpicker.overlays.default
  nurpkgs.overlays.default
  nixgl.overlay

  (final: prev: {
    nodePackages =
      prev.nodePackages
      // {
        neovim = final.neovim-node-client;
      };
  })

  (import ./extend-lib.nix withSystem inputs)
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

