{ pkgs, ... }: {
    home.packages = with pkgs; [
        eww-wayland
    ];
}
