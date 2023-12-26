# Initialize XDG environment variables that aren't
# set up on Hyprland.

{ pkgs, ... }:
{
	home.file = {
		".config/user-dirs.dirs".text = ''
			XDG_DESKTOP_DIR="$HOME/Desktop"
			XDG_DOCUMENTS_DIR="$HOME/Documents"
			XDG_DOWNLOAD_DIR="$HOME/Downloads"
			XDG_MUSIC_DIR="$HOME/Music"
			XDG_PICTURES_DIR="$HOME/Pictures"
			XDG_PUBLICSHARE_DIR="$HOME/Public"
			XDG_TEMPLATES_DIR="$HOME/Templates"
			XDG_VIDEOS_DIR="$HOME/Videos"
		'';
	};
}
