{lib, ...}: let
  private =
    if builtins.pathExists ./private.nix
    then import ./private.nix
    else lib.trivial.warn "${builtins.toString ./.}/private.nix does not exist" {user = {};};
in {
  inherit (private) user;

  core = {
    editor = "nvim";
    pager = "delta";
  };

  delta = {
    features = [
      "line-numbers"
      "decorations"
    ];

    line-numbers = true;
  };

  init = {
    defaultBranch = "master";
  };

  web.browser = "firefox";
  gpg.format = "ssh";
  push.autoSetupRemote = true;
}
