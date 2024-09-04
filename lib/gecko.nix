_: {
  withGecko = pkg: {
    mkProfile = {
      binary-path ? pkg + "/bin/${pkg.pname}",
      icon-path ? "${pkg}/lib/${pkg.pname}/browser/chrome/icons/default/default128.png",
      instance-name ? pkg.pname,
      profile ? "$USER",
      display-name ? "Floorp - ${profile}",
    }: {
        name = display-name;
        actions = {
          "new-window" = {
            exec = "${pkg} --new-instance %U";
          };

          "new-private-window" = {
            exec = "${pkg} --private-window %U";
          };
        };
        categories = ["Network" "WebBrowser"];
        comment = "A beautiful, customizable gecko-based Japanese browser.";
        exec = "${binary-path} --name ${instance-name} %U -p \"${profile}\"";
        genericName = "Web Browser";
        startupNotify = true;
        type = "Application";
        icon = icon-path;
        mimeType = ["text/html" "text/xml" "application/xhtml+xml" "application/vnd.mozilla.xul+xml" "x-scheme-handler/http" "x-scheme-handler/https"];
    };
  };
}
