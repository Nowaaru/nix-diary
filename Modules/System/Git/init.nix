{ pkgs, ... }:
{
	environment.systemPackages = with pkgs; [
		git
		gh
	];
}
