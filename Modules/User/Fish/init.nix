{ pkgs, ... }:
{
	programs.fish = {
		enable = true;
		interactiveShellInit = ''
			set -U fish_greeting
			ncneofetch
			fish_vi_key_bindings
		'';
	};
}
