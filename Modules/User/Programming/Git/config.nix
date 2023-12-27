let private = import ./private.nix; in {
  inherit (private) core user;
  init = {
    defaultBranch = "main";
  };
}
