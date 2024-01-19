# do not write this file
#
# you will break it more
# than it is already broken now
# will deny any PRs made to this file
{
	description = "Noire's nonfunctional user flake.";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		nix-colors.url = "github:misterio77/nix-colors";
        lanzaboote.url = "github:nix-community/lanzaboote";
        nur.url = "github:nix-community/NUR";
        rust-overlay.url = "github:oxalica/rust-overlay";

        neovim-images-overlay.url = "github:nix-community/neovim-nightly-overlay";

		home-manager = {
			url = "github:nix-community/home-manager/master";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};


	outputs = { self, rust-overlay, nix-colors, home-manager, nixpkgs, lanzaboote, nur, ... } @inputs: let
		system = "x86_64-linux";
		lib = nixpkgs.lib;
		pkgs = import nixpkgs { 
			inherit system; 
			config = { 
				allowUnfree = true; 
				permittedInsecurePackages = [ "electron-25.9.0" ]; 
			};
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
			extraSpecialArgs = { inherit inputs nix-colors; };
			modules = [ 
				nur.nixosModules.nur
				./home.nix 
			];
		};
	};
}
