{
  pkgs,
  inputs,
  ...
}: {
  xdg.desktopEntries.roblox-studio = {
    name = "Roblox Studio";
    genericName = "roblox-studio";
    comment = "Roblox development environment";
    exec = "flatpak run org.vinegarhq.Vinegar studio run";
    icon = "${inputs.self + /assets/icons/roblox-studio-128.png}";
    type = "Application";
    categories = ["Game" "Graphics" "Development" "Education" "3DGraphics"];
    startupNotify = true;
  };

  home = {
    packages = with pkgs; [
      (writeShellScriptBin "roblox-studio" ''
        flatpak run org.vinegarhq.Vinegar studio run
      '')

      vinegar
      rojo
    ];

    file = {
      ".config/vinegar/config.toml".text = ''
        [splash]
        enabled = false
        [studio]
        dxvk = true
        renderer = "D3D11"
        launcher="${pkgs.gamemode}/bin/gamemoderun"
      '';
    };
  };
}
