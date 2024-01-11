{pkgs, ...}:
    /*
     * flexico
     * hardcore
     * hybrid
     * japanesque
     * kangawabones
     * purpurite
     */
{
    home.packages = with pkgs; [
		kitty-themes
        kitty
    ];

    programs.kitty = {
        enable = true;
        theme = "kanagawabones";
        shellIntegration.enableFishIntegration = true;

        font = {
            name = "SpaceMono";
            package = (pkgs.nerdfonts.override { fonts = [ "SpaceMono" ]; });
        };
    };
}
