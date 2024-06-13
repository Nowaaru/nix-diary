{ pkgs, ... }:
{
	environment = {
		sessionVariables = {
			WINEESYNC="1";
		};

		systemPackages = with pkgs; [
			mono

			winetricks
			wineWowPackages.full
		];
	};

	nixpkgs = {
		overlays = [
			# (import ./overlay)
		];
	};
}
