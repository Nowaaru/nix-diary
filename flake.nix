{
  	description = "A very basic flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/release-23.11";
		nix-colors.url = "github:misterio77/nix-colors";
		home-manager = {
			url = "github:nix-community/home-manager/release-23.11";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};


	outputs = { self, home-manager, nixpkgs, ... } @inputs: let
		system = "x86_64-linux";
		lib = nixpkgs.lib;
		pkgs = import nixpkgs { inherit system; config = { allowUnfree = true; }; };
	in {
      		nixosConfigurations = {
			lastation = lib.nixosSystem {
	  			specialArgs = { inherit inputs; };
	  			modules = [ 
					./configuration.nix
					home-manager.nixosModules.home-manager 
					{ home-manager.useGlobalPkgs = true; }
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
