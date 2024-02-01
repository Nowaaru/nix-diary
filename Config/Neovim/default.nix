{lib}: let
  config = import ./config.nix {
    inherit lib;
  };
in {
  inherit config;
}
