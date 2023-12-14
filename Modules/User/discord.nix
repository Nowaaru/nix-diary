{ pkgs, ...}:
{
	home.packages = with pkgs; 
	let
		discord-wayland = pkgs.discord.overrideAttrs ( old: rec {
			commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
	  	});
		obsidian-wayland = pkgs.obsidian.overrideAttrs ( old: rec {
			commandLineArgs = "--disable-gpu=true";
	  	});
	in
	[
	  # discord-wayland
	  vesktop
	  obsidian-wayland
	];
}
