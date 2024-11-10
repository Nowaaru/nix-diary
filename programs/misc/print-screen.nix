{ pkgs, inputs, ... }: {
	home.packages = with pkgs; [
    gpu-screen-recorder
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast 
	];
}

