{lib}: {
  build.viAlias = true;
  build.vimAlias = true;

  vim = {
    autoIndent = true;
    autocomplete.enable = true;

    autopairs.enable = true;
    autopairs.type = "nvim-autopairs";

    bell = "visual";

    filetree.nvimTreeLua = {
      enable = true;
      closeOnFileOpen = true;
      closeOnLastWindow = true;
      disableNetRW = true;
    };

    keys.whichKey = {
      enable = true;
    };

    theme = {
      name = lib.mkForce "catppuccin";
    };
  };
}
