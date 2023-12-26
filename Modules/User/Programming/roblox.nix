{ pkgs, ... }:
{
	home.file = {
		# ".config/vinegar/config.toml".text = ''
		#	[env]
		#	WINEFSYNC = "1"
		#	
		#	[splash]
		#	style = "familiar"
		#
		#	[player]
		#	dxvk = false
		#
		#	[studio]
		#	gamemode = true
		#	renderer = "OpenGL"
		# '';
	};

	home.packages = with pkgs; [
		vinegar
	];
}
