{ pkgs, ... }:
{
    programs.fish.enable = true;

    environment.systemPackages = with pkgs; [
        moonlight-qt
        moonlight-embedded
    ];
}
