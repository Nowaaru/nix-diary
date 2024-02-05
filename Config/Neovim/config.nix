{lib}:
with lib; {
  build.viAlias = mkForce true;
  build.vimAlias = mkForce true;

  vim = {
    autoIndent = mkForce true;
    autocomplete.enable = mkForce true;

    autopairs.enable = mkForce true;
    autopairs.type = mkForce "nvim-autopairs";

    bell = mkForce "visual";

    filetree.nvimTreeLua = {
      enable = mkForce true;
      closeOnFileOpen = mkForce true;
      closeOnLastWindow = mkForce true;
      disableNetRW = mkForce true;
    };

    keys.whichKey.enable = mkForce true;
    theme.name = mkForce "onedark";
  };
}
