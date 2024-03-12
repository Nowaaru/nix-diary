{lib}: {
  keys = rec {
    map = mode: from: to: {
      inherit from to;
      type = mode;
    };

    noremap = mode: from: to:
      (map mode from to) // {recursive = true;};

    # Normal mode remap.
    # deadnix: skip
    nnoremap = noremap "n";
    nmap = map "n";

    # Operator pending mode (inputting motions, etc..).
    # deadnix: skip
    onoremap = noremap "o";
    omap = map "o";

    # Command line mode (:).
    # deadnix: skip
    cnoremap = noremap "c";
    cmap = map "c";

    # Visual mode bindings.
    # deadnix: skip
    xnoremap = noremap "x";
    xmap = map "x";

    # Select mode bindings (R/r, S/s)
    # deadnix: skip
    snoremap = noremap "s";
    smap = map "s";

    # Terminal mode bindings.
    # deadnix: skip
    tnoremap = noremap "s";
    tmap = map "s";

    # Visual and Select mode bindings.
    # deadnix: skip
    vnoremap = noremap "v";
    vmap = map "v";
  };

  fn = {
    parseKeyMap = keyMapArray:
      with lib;
        lib.mkMerge (lists.foldl'
          (
            acc: v:
            # why is the merge operator '//'
              acc
              ++ [
                (mkForce (attrsets.setAttrByPath [
                    "${v.type}${
                      if (attrsets.hasAttrByPath ["recursive"] v)
                      then "nore"
                      else ""
                    }map"
                    v.from
                  ]
                  v.to))
              ]
          ) []
          keyMapArray);
  };
}
