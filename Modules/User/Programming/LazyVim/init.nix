{ pkgs, lib, ... }:
let
  nvim_target = "~/.config/nvim";
  branch = "main";
  git = "${pkgs.git}/bin/git";
in
{
	# Automatically clone LazyVim into configuration
  # after a Home Manager rebuild run.
	home.activation = {
		lazyvim = lib.hm.dag.entryAfter ["writeBoundary"] '' 
			#If the '${nvim_target}' folder doesn't exist it'll clone, otherwise it won't
			#It won't clone if the folder already exists, this would be useful in case there is another configuration that I don't want overwritten

      
			if [ ! -d ${nvim_target} ];
			then
				${git} clone https://github.com/Nowaaru/vim ${nvim_target}
      else
        cd ${nvim_target}
        ${git} fetch origin ${branch}
        ${git} reset --hard origin/${branch}
			fi
		'';
	}; 

  home.packages = with pkgs; [
    nil
  ];

  
  programs.neovim.plugins = import ./plugins.nix;
}

