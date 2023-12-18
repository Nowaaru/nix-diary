{ pkgs, ... }:
let
	version = "9.0-rc2";
in
{
	programs.wine = {
		enable = true;
		version = "${version}";
		source = pkgs.fetchurl {
			url = "https://dl.winehq.org/wine/source/${version}/wine-${version}.tar.xz";
			sha256 = "04am0sn5xfvg5h24kdw117ms2gxh6vv035035y7ic79krd2095fy"; # Replace with the actual sha256 hash
		};
	};
}
