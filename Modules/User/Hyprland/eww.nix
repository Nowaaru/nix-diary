{ pkgs, ... }: {
    home.packages = with pkgs; [
        eww-wayland
    ];

    nixpkgs = {
        overlays = 
            [
                (final: prev:
                    {
                        eww = 
                            prev.eww-wayland.overrideAttrs (old: rec {
                                    src = pkgs.fetchFromGitHub {
                                      owner = "elkowar";
                                      repo = "eww";
                                      rev = "65d622c81f2e753f462d23121fa1939b0a84a3e0";
                                      hash = "sha256-MR91Ytt9Jf63dshn7LX64LWAVygbZgQYkcTIKhfVNXI=";
                                    };
                            });

                        eww-wayland = final.eww.override { withWayland = true; };
                    })
            ];
    };
}
