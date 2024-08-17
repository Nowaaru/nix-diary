{ configure, ... }: {
  programs.bun = {
    enable = true;
    enableGitIntegration = true;
    settings = configure "bun";
  };
}

