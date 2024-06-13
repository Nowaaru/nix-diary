{pkgs, ...}: let
  floorpPath = "${pkgs.floorp-unwrapped}/bin/floorp";
in {
  xdg.desktopEntries.floorp = {
    name = "Floorp";
    actions = {
      "new-window" = {
        exec = "${floorpPath} --new-instance %U";
      };

      "new-private-window" = {
        exec = "${floorpPath} --private-window %U";
      };
    };
    categories = ["Network" "WebBrowser"];
    comment = "A beautiful, customizable gecko-based Japanese browser.";
    exec = "${floorpPath} --name floorp %U";
    genericName = "Web Browser";
    startupNotify = true;
    type = "Application";
    icon = "${pkgs.floorp-unwrapped}/lib/floorp/browser/chrome/icons/default/default128.png";
    mimeType = ["text/html" "text/xml" "application/xhtml+xml" "application/vnd.mozilla.xul+xml" "x-scheme-handler/http" "x-scheme-handler/https"];
  };

  home.packages = with pkgs; [
    floorp-unwrapped
  ];
}
