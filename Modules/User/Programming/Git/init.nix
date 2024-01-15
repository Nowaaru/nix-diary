{ pkgs, lib, ... }: 
{
	home.packages = with pkgs; [
		lazygit
	];

  programs.git = let extraConfig = import ./config.nix { inherit lib; }; in {
    inherit extraConfig;
    enable = true;
  };
}
