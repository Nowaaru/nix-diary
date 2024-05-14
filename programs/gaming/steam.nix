{pkgs, ...}: {
  home.packages = with pkgs; [
    steamtinkerlaunch
    steam-run
  ];
}
