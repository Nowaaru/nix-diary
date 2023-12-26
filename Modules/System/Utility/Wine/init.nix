{ pkgs, ... }:
{
	environment = {
		sessionVariables = {
			WINEESYNC="1";
		};

		systemPackages = with pkgs; [
			mono

			winetricks
			wineWowPackages.stagingFull
		];
	};

	nixpkgs = {
		# overlays = [
		# 	(import ./overlay)
		# ];
	};
}
