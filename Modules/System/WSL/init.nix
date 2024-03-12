{ pkgs, ...}: {
	environment.systemPackages = with pkgs; [
		home-manager
		git
	];

	programs.fish = {
		enable = true;
	};
}
