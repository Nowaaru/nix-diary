{ pkgs, lib, configure, ... }: 
{
	home.packages = with pkgs; [
		lazygit
	];

  programs.git = let extraConfig = (import ./config.nix { inherit lib; }) // (configure "git"); in {
    inherit extraConfig;
    enable = true;
  };
}
