lib:
with lib; {
  mkIfElse = predicate: yes: no:
    mkMerge [
      (mkIf predicate yes)
      (mkIf (!predicate) no)
    ];
}
