{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      (writeShellScriptBin "vinegar" ''
        flatpak run org.vinegarhq.Vinegar studio run
      '')
      rojo
    ];
    file = {
      ".config/vinegar/config.toml".text = ''
        [env]
        WINEESYNC = "0"
        [splash]
        enabled = false
        [player]
        renderer = "Vulkan"
        dxvk = false
        [studio]
        dxvk = false
        renderer = "Vulkan"
      '';
    };
  };
}
