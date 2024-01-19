{ pkgs, inputs, lib, ... }:
let
  nvim_target = "~/.config/nvim";
  nvim_origin = "~/.diary/Config/LazyVim/";
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
				#${git} clone https://github.com/Nowaaru/vim ${nvim_target}
				${git} clone ${nvim_origin} ${nvim_target}
      else
        cd ${nvim_target}
        ${git} fetch origin ${branch}
        ${git} reset --hard origin/${branch}
			fi
		'';
	}; 

  home.packages = with pkgs; [
    luajitPackages.magick
    # lua54Packages.jsregexp
    # lua54Packages.lua
    luau
    lua

    nil
    imagemagickBig
    ueberzugpp
  ];

    nixpkgs.overlays = [
        inputs.neovim-images-overlay.overlay
    ];
    programs.neovim = {
        enable = true;
        package = pkgs.neovim-nightly;
        extraLuaPackages = ps: [ ps.magick ];
    };
}

