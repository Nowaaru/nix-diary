{pkgs, configure, ... }: {
    # fuzzel -D no -p " " --tabs=4 --line-height=17 -f "JetBrainsMono:weight=light"
    home.packages = with pkgs; [
        fuzzel
    ];

    programs.fuzzel.settings = configure "fuzzel";
}
