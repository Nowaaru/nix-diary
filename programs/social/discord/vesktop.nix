{pkgs, master, ...}: {
  home.packages = with pkgs; [
    master.vesktop
    arrpc
  ];
}
