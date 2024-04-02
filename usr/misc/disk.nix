{ pkgs, ... }:
{
	home.packages = with pkgs; [
		udiskie
		ntfs3g
		psmisc

		gparted
		parted
	];
}
