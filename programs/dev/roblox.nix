{
  pkgs,
  inputs,
  ...
}: {
  xdg.desktopEntries.roblox-studio = {
    name = "Roblox Studio";
    genericName = "roblox-studio";
    comment = "Roblox development environment";
    exec = "vinegar studio run";
    icon = "${inputs.self + /assets/icons/roblox-studio-128.png}";
    type = "Application";
    categories = ["Game" "Graphics" "Development" "Education" "3DGraphics"];
    startupNotify = true;
  };

  home = {
    packages = with pkgs; [
      (writeShellScriptBin "roblox-studio" ''
        vinegar studio run
      '')

      vinegar
      rojo
    ];

    file = {
      ".config/vinegar/config.toml".text = ''
        [env]
        WINEESYNC = "1"
        [splash]
        enabled = false
        [studio]
        dxvk = false
        renderer = "Vulkan"
      '';
    };
  };
}
