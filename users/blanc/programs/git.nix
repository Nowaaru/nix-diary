{ configure, ...}: {
  programs = {
    lazygit = {
      enable = true;
      settings = configure "git";
    };
  };
}
