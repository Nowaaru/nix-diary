{lib, ...}: {
  withInputs = what: args: let
    imported = import what;
    parameters = builtins.functionArgs imported;
    unfillableParameters = builtins.attrNames (lib.attrsets.filterAttrs (k: v: !v && what ? k)) parameters;
    amtUnfillable = builtins.length unfillableParameters;
  in
    if
      (lib.asserts.assertMsg (builtins.isFunction imported
        || (lib.asserts.assertMsg (
            amtUnfillable
            == 0
          ) "parameters ${lib.lists.imap0 (k: v: "${
              if (k - 1 == amtUnfillable)
              then "'${v},' and"
              else
                (
                  if (k == amtUnfillable)
                  then "'${v}'"
                  else "'${v}',"
                )
            }")
            unfillableParameters} do not have defaults and are not filled in by parameter 'args'") {
        }) "input function is not of type function (got ${builtins.typeOf what})")
    then (import what args)
    else {};
}
