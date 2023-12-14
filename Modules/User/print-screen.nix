{ pkgs, ... }: {
	home.packages = with pkgs; [
		shotman
		copyq
		slurp
	];
}

