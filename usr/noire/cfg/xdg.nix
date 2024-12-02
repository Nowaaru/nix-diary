{
  inputs,
  pkgs,
  lib,
  ...
}: {
  enable = true;
  mime.enable = true;
  mimeApps.enable = true;

  userDirs = {
    enable = true;
    createDirectories = true;
  };

  portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

  desktopEntries = with lib.gamindustri.xdg; {
    roblox-studio-umu-launcher = let
      umu-home =
        inputs.umu-launcher.packages.x86_64-linux.umu;
    in
      mkShortcut {
        instance-name = "Roblox Studio - UMU Launcher";
        icon = "org.vinegarhq.Vinegar.studio";

        settings = {
          X-Flatpak = "org.vinegarhq.Vinegar";
        };

        mimeType = [
          "application/x-roblox-rbxl"
          "application/x-roblox-rbxlx"
          "x-scheme-handler/roblox-studio"
          "x-scheme-handler/roblox-studio-auth"
        ];

        executable =
          pkgs.writeScript "roblox-studio-umu"
          ''
            #!/usr/bin/env bash

            export GAMEID=0
            export PROTONPATH="$HOME/.local/share/Steam/compatibilitytools.d/UMU-Proton-9.0-3.2/"
            export WINEPREFIX="$HOME/.var/app/org.vinegarhq.Vinegar/data/vinegar/prefixes/studio"

            ${umu-home}/bin/umu-run "$(find "$HOME"/.var/app/org.vinegarhq.Vinegar/data/vinegar/versions/ -name "RobloxStudioBeta.exe")"
          '';
      };
  };

  mimeApps.defaultApplications = {
    "default-web-browser" = "brave-browser.desktop";
    "text/html" = "brave-browser.desktop";
    "x-scheme-handler/http" = "brave-browser.desktop";
    "x-scheme-handler/https" = "brave-browser.desktop";
    "x-scheme-handler/about" = "brave-browser.desktop";
    "x-scheme-handler/unknown" = "brave-browser.desktop";
  };
}
