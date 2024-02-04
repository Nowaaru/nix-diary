{lib}: let
  util = import ./util.nix {inherit lib;};
  keys = import ./keys.nix {inherit lib;};
  config = import ./config.nix {
    inherit lib;
  };

  # deadnix: skip
  selfTrace = a: builtins.trace (builtins.toJSON a) a;
in
  with lib; {
    config = mkMerge [config (attrsets.setAttrByPath ["vim"] (util.fn.parseKeyMap keys))];
  }
