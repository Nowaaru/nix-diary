{ pkgs, ... }:
{
	programs.fish = {
		enable = true;
		shellInit = ''
			set -Ux DIARY ~/.diary
			source $DIARY/Config/Fish/init.fish
		'';
		interactiveShellInit = ''
			set -U fish_greeting
			ncneofetch
			fish_vi_key_bindings
		'';
	};
}
