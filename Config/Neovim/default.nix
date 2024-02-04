{lib}: let
  util = import ./util.nix {inherit lib;};
  keys = import ./keys.nix {inherit lib;};
  config = import ./config.nix {
    inherit lib;
  };

  selfTrace = a: builtins.trace (builtins.toJSON a) a;
in
  with lib; {
    config = selfTrace (mkMerge [config (attrsets.setAttrByPath ["vim"] (util.fn.parseKeyMap keys))]);
  }
/*
HEELP HELP ME PLEASE
config = selfTrace (config // (attrsets.setAttrByPath ["vim"] (util.fn.parseKeyMap keys)));config = selfTrace (config // (attrsets.setAttrByPath ["vim"] (util.fn.parseKeyMap keys)));
*/

