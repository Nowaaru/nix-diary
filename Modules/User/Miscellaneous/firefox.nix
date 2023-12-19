{ pkgs, ... }:
{
	home.packages = with pkgs; [
		firefox
	];

	programs.firefox = {
		profiles = {
			"noire" = {
				extensions = {
				
				};
			};
		};
	};
}
