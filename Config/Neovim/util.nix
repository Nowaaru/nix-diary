{lib}: {
  keys = rec {
    map = mode: from: to: {
      inherit from to;
      type = mode;
    };

    # Normal mode remap.
    # deadnix: skip
    nnoremap = map "n";

    # Operator pending mode (inputting motions, etc..).
    # deadnix: skip
    onoremap = map "o";

    # Command line mode (:).
    # deadnix: skip
    cnoremap = map "c";

    # Visual mode bindings.
    # deadnix: skip
    xnoremap = map "x";

    # Select mode bindings (R/r, S/s)
    # deadnix: skip
    snoremap = map "s";

    # Terminal mode bindings.
    # deadnix: skip
    tnoremap = map "s";

    # Visual and Select mode bindings.
    # deadnix: skip
    vnoremap = map "v";
  };

  fn = {
    parseKeyMap = keyMapArray:
      with lib;
        lib.mkMerge (lists.foldl'
          (
            acc: v:
            # why is the merge operator '//'
              acc ++ [(attrsets.setAttrByPath ["${v.type}noremap" v.from] v.to)]
          ) []
          keyMapArray);
  };
}
