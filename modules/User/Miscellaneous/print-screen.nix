{ pkgs, ... }: {
	home.packages = with pkgs; [
    gpu-screen-recorder
    grimblast
		copyq
		slurp
		grim
	];
}

