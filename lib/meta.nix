{lib, ...}: {
  mkIfElse = with lib;
    predicate: yes: no:
      mkMerge [
        (mkIf predicate yes)
        (mkIf (!predicate) no)
      ];

  selfTrace = this: builtins.trace this this;

  withInputs = this: with_inputs: let
    imported = import this;
    is_attrset = builtins.isAttrs imported;
    parameters = builtins.functionArgs imported;
    unfillableParameters = builtins.attrNames (lib.attrsets.filterAttrs (k: v: !v && this ? k)) parameters;
    amtUnfillable = builtins.length unfillableParameters;
  in
    if is_attrset
    then imported
    else
      (
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
                unfillableParameters} do not have defaults and are not filled in by parameter 'args'") {})
          "input function is not of type function (got ${builtins.typeOf this})")
        then (import this (lib.attrsets.filterAttrs (k: _: (builtins.elem k (builtins.attrNames parameters))) with_inputs))
        else {}
      );
}
