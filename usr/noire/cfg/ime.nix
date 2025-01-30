{pkgs, ...}: {
  inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc-ut
      fcitx5-rose-pine
    ];
  };
}
