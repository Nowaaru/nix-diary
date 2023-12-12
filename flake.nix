{
  	description = "A very basic flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/release-23.11";
		nix-colors.url = "github:misterio77/nix-colors";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};


	outputs = { self, home-manager, nixpkgs, ... } @inputs: let
		system = "x86_86-linux";
		lib = nixpkgs.lib;
		pkgs = import nixpkgs { inherit system; config = { allowUnfree = true; }; };
	in {
      		nixosConfigurations = {
			lastation = lib.nixosSystem {
	  			specialArgs = { inherit inputs; };
	  			modules = [ ./configuration.nix ];
			};
		};

		homeConfigurations = {
			"noire@lastation" = home-manager.lib.homeManagerConfiguration {
				extraSpecialArs = { inherit inputs; };
				modules = [ ./home.nix ];
			};
		};
	};
}
