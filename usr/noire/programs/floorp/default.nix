{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    floorp-unwrapped
    (pkgs.writeTextDir "share/applications/floorp.desktop" ''
      [Desktop Entry]
      Name=Floorp
      Actions=new-private-window;new-window;profile-manager-window
      Comment=A beautiful, customizable gecko-based Japanese browser.
      MimeType=text/html;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;x-scheme-handler/http;x-scheme-handler/https
      Exec=floorp --name floorp %U
      Terminal=false
      Icon=${pkgs.floorp-unwrapped.out + "/lib/floorp/browser/chrome/icons/default/default128.png"}
      Type=Application
      Categories=Network;WebBrowser
      StartupNotify=true
      GenericName=Web Browser
    '')
  ];
}
