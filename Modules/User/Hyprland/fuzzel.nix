{pkgs, ... }: {
    # fuzzel -D no -p " " --tabs=4 --line-height=17 -f "JetBrainsMono:weight=light"
    home.packages = with pkgs; [
        fuzzel
    ];

    programs.fuzzel.settings = {
        main = {
            terminal = "${pkgs.kitty}/bin/kitty";
            layer = "top";

            prompt = ''"  "'';
            dpi-aware = "no";
            font = "JetBrainsMono:weight=light";

            line-height = 17;
            image-size-ratio = 1;
            tabs = 4;
        };
    };
}
