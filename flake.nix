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
    rust-overlay.url = "github:oxalica/rust-overlay";
    nur.url = "github:nix-community/NUR";

    /*
    theme-flake-test = {
      url = "path:/home/noire/Documents/nix-flakes/theme.nix";
      flake = true;
    };
    */

    /*
    agenix
    */
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = ""; # please god i pray that not a single mac user sees this config option
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    /*
    neovim
    */

    neovim-flake.url = "github:NotAShelf/neovim-flake";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    /*
    home computer things
    */

    lanzaboote.url = "github:nix-community/lanzaboote";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    xdg-desktop-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";
  };

  outputs = {
    self,
    nixpkgs,
    neovim-flake,
    home-manager,
    nix-colors,
    lanzaboote,
    hyprpicker,
    agenix,
    nur,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        hyprpicker.overlays.default
      ];
      config = {
        allowUnfree = true;
        permittedInsecurePackages = ["electron-25.9.0"];
      };
    };
  in {
    nixosConfigurations = {
      lastation = lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          lanzaboote.nixosModules.lanzaboote
          agenix.nixosModules.default
          {
            environment.systemPackages = [agenix.packages.${system}.default];
          }
          ./Core/configuration.nix
        ];
      };

      wslastation = lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          agenix.nixosModules.default
          ./Core/configuration-wsl.nix
        ];
      };
    };

    homeConfigurations."lastation" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {inherit inputs nix-colors;};
      modules = [
        nur.nixosModules.nur
        ./home.nix
      ];
    };

    /*
    bare-bones neovim config
    */
    homeConfigurations."planeptune" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {inherit inputs nix-colors;};
    };
  };
}
