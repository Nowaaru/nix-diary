{ pkgs, ... }: {
  home.packages = with pkgs; [
		(nerdfonts.override { fonts = [ "JetBrainsMono" "FiraMono" "FiraCode" "SpaceMono" ]; })
  ];
}
