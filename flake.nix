{
	description = "Noire's personalized user flake.";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/release-23.11";
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
		lanzaboote.url = "github:nix-community/lanzaboote";
		nix-colors.url = "github:misterio77/nix-colors";
		nur.url = "github:nix-community/NUR";

		home-manager = {
			url = "github:nix-community/home-manager/release-23.11";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};


	outputs = { self, home-manager, nixpkgs, nixpkgs-unstable, lanzaboote, nur, ... } @inputs: let
		system = "x86_64-linux";
		lib = nixpkgs.lib;
		unstable = import nixpkgs-unstable { 
			inherit system;
		};
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
			extraSpecialArgs = { inherit inputs unstable pkgs; };
			modules = [ 
				nur.nixosModules.nur
				./home.nix 
			];
		};
	};
}
