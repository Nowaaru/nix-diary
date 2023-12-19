{ inputs, config, pkgs, ...}: 
	with config.nur.repos.rycee.firefox-addons; [
		adnauseam
		bitwarden 
	]	
