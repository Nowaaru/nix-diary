{ lib, pkgs }: rec {
    color = rec {
        isConverted =
            what:
                lib.strings.hasPrefix "rgb" what;

        convertRgb =
            from:
            ( 
                strippedFrom:
                    if (!isConverted from) then
                        if (builtins.stringLength strippedFrom ) > 6 then
                            "rgba(${strippedFrom})"
                        else "rgb(${strippedFrom})"
                    else from
            ) (lib.strings.removePrefix "#" from);

        gradient =
            from: to: deg:
            (
                c_from: c_to: c_deg:
                (
                    "${c_from} ${c_to} ${c_deg}"
                )
            ) (convertRgb from) (convertRgb to) (
                if (builtins.isInt deg) || (builtins.isFloat deg) then
                    "${builtins.toString deg}deg"
                else "0deg"
            );
    };

    str = {
        applySwayTheme = theme: 
            "${pkgs.swww}/bin/swww img ${theme.background}";
    };

    log = {
        self-trace = what:
            builtins.trace what what;
    };
}
