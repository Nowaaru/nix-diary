{pkgs, ...}: {
  home.file = let 
    macos-cursor = pkgs.fetchzip {
      name = "macOS-hyprcursor-svg-white";
      url = "https://github.com/driedpampas/macOS-hyprcursor/releases/download/v1/macOS.Hyprcursor.SVG.White.tar.gz";
      hash = "sha256-c3sYpdFZgN6vxG+Pfj6D69QQvuyGp673TI9JsaUsLFc=";
    }; 
  in {
    "hyprland-macos-cursor" = {
      enable = true;
      target = ".local/share/icons/macos-cursor";
      source = macos-cursor;
    };
  };
}
