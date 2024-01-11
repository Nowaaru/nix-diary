{
	description = "Noire's personalized user flake.";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		nix-colors.url = "github:misterio77/nix-colors";
        lanzaboote.url = "github:nix-community/lanzaboote";
        nur.url = "github:nix-community/NUR";
        rust-overlay.url = "github:oxalica/rust-overlay";

		home-manager = {
			url = "github:nix-community/home-manager/master";
			inputs.nixpkgs.follows = "nixpkgs";
		};
        

	};


	outputs = { self, rust-overlay, home-manager, nixpkgs, lanzaboote, nur, ... } @inputs: let
		system = "x86_64-linux";
		lib = nixpkgs.lib;
		pkgs = import nixpkgs { 
			inherit system; 
			config = { 
				allowUnfree = true; 
				permittedInsecurePackages = [ "electron-25.9.0" ]; 
			};

            /*
            overlays = [
                ( 
                    { fetchurl, fetchpatch }:
                        final: prev: {
                            wine = prev.wine.overrideAttrs (old: {
                                src = fetchTarball {
                                    url = "https://dl.winehq.org/wine/source/9.0/wine-9.0-rc4.tar.xz";
                                };
                                patches =
                                (old.patches or [ ])
                                ++ [
                                    # upstream issue: https://bugs.winehq.org/show_bug.cgi?id=55604
                                    # Here are the currently applied patches for Roblox to run under WINE:
                                    (fetchpatch {
                                        name = "vinegar-wine-segrevert.patch";
                                        url = "https://raw.githubusercontent.com/flathub/org.vinegarhq.Vinegar/8fc153c492542a522d6cc2dff7d1af0e030a529a/patches/wine/temp.patch";
                                        hash = "sha256-AnEBBhB8leKP0xCSr6UsQK7CN0NDbwqhe326tJ9dDjc=";
                                    })
                                ];
                            });
                        }
                )
            ];
            */
		}; 
	in {
    nixosConfigurations = {
			lastation = lib.nixosSystem {
				specialArgs = { inherit inputs; };
				modules = [ 
					lanzaboote.nixosModules.lanzaboote
					./configuration.nix
				];
			};
		};

		homeConfigurations."lastation" = home-manager.lib.homeManagerConfiguration {
			inherit pkgs;
			extraSpecialArgs = { inherit inputs;};
			modules = [ 
				nur.nixosModules.nur
				./home.nix 
                ({
                    nixpkgs.overlays = [ 
                        (let
                            neovim-nightly-overlay = import (builtins.fetchTarball {
                                url = "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
                            });
                        in 
                        self: super:
                        {
                            inherit (neovim-nightly-overlay self super) neovim-nightly;
                        })
                    ];
                    
                    # programs.neovim = {
                    #     enable = true;
                    #     package = pkgs.neovim-nightly;
                    #     extraLuaPackages = ps: [ ps.magick ];
                    # };
                    
                })
			];
		};
	};
}
