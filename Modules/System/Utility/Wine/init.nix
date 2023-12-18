{ pkgs, ... }:
{
	environment.systemPackages = with pkgs; [
		wine64
	];

	nixpkgs = {
		overlays = [
			(import ./overlay)
		];
	};
}
