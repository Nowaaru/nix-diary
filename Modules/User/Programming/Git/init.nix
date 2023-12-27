{ pkgs, ... }: 
{
	home.packages = with pkgs; [
		lazygit	
	];

  programs.git = let extraConfig = import ./config.nix; in {
    inherit extraConfig;
    enable = true;
  };
}
