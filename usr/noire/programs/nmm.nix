{inputs, ...}: {
  # Enable my mod manager.
  programs.nix-mod-manager = {
    enable = true;
    clients = {
      monster-hunter-world = let
        inherit (inputs.nnmm.lib.nnmm) mkLocalMod fetchers providers;
        inherit (inputs.home-manager.lib.hm) dag;
      in
        with inputs.mods.monster-hunter-world; {
          enable = true;
          rootPath = ".local/share/Steam/steamapps/common/Monster Hunter World";
          deploymentType = "loose";

          modsPath = ".";
          binaryPath = ".";

          binaryMods = binary;

          mods = lib.mkMerge [
            efx
            # npc

            # nsfw
            sfw
            misc
            # misc-nsfw
            # monster
          ];
        };
    };
  };
}
