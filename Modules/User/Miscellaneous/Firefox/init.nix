{ inputs, config, pkgs, ... }:
{
	home.packages = with pkgs; [
        librewolf
	];

	programs.firefox = {
		enable = true;
		package = pkgs.wrapFirefox pkgs.firefox-unwrapped 
		{
			extraPolicies = import ./policies.nix {
				inherit config inputs pkgs;
			};
		};
		profiles = {
			noire = {
				id = 0;
				name = "Noire";
				isDefault = true;

				path = "~/.firefox";
                settings = import ./preferences.nix {
                    inherit config inputs pkgs;
                };
				bookmarks = import ./bookmarks.nix {
					inherit config inputs pkgs;
				};
				extensions = import ./extensions.nix {
					inherit config inputs pkgs;
				};
			};
		};
	};
}
