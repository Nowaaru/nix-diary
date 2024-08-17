{
  lib,
  ...
}: {
  core = {
    editor = lib.mkDefault "nvim";
    pager = lib.mkDefault "delta";
  };

  delta = {
    features = lib.mkDefault [
      "line-numbers"
      "decorations"
    ];

    line-numbers = true;
  };

  init = {
    defaultBranch = lib.mkDefault "master";
  };

  user.signingKey = lib.mkDefault "~/.ssh/id_ed25519.pub";

  web.browser = lib.mkDefault "firefox";
  gpg.format = lib.mkDefault "ssh";
  push.autoSetupRemote = lib.mkDefault true;
  commit.gpgsign = lib.mkDefault true;
}
