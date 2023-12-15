{ pkgs, ... }: {
	home.packages = with pkgs; [
		copyq
		slurp
		grim
	];
}

