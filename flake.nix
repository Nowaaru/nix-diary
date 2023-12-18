{
	description = "Noire's personalized user flake.";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/release-23.11";
		lanzaboote.url = "github:nix-community/lanzaboote";
		nix-colors.url = "github:misterio77/nix-colors";

		home-manager = {
			url = "github:nix-community/home-manager/release-23.11";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};


	outputs = { self, home-manager, nixpkgs, lanzaboote, ... } @inputs: let
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
					./configuration.nix
					lanzaboote.nixosModules.lanzaboote
				];
			};
		};

		homeConfigurations."lastation" = home-manager.lib.homeManagerConfiguration {
			inherit pkgs;
			extraSpecialArgs = { inherit inputs pkgs; };
			modules = [ ./home.nix ];
		};
	};
}
