{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
      kitty
      kitty-img
    ];
}
