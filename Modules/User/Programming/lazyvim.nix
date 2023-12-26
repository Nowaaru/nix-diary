{pkgs, lib, ...}:{
	#Custom system activation script that runs whenever I use 'nix-rebuild'
	home.activation = {
		lazyvim = lib.hm.dag.entryAfter ["writeBoundary"] '' 
			#If the '~/.config/nvim' folder doesn't exist it'll clone, otherwise it won't
			#It won't clone if the folder already exists, this would be useful in case there is another configuration that I don't want overwritten

			if [ ! -d /home/noire/.config/nvim ];
			then
				${pkgs.git}/bin/git clone https://github.com/Nowaaru/vim /home/noire/.config/nvim/
			fi
		'';
	}; 
}
