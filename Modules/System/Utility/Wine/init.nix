{ pkgs, ... }:
{
	environment = {
		systemPackages = with pkgs; [
			mono

			winetricks
			wine64
			wine
		];
		
	};

	nixpkgs = {
		overlays = [
			(import ./overlay)
		];
	};
}
