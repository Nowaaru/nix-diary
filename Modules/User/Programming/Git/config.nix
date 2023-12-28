let private = import ./private.nix; in {
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
    defaultBranch = "main";
  };
}
