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

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    /*
    neovim
    */

    neovim-images-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-flake.url = "github:jordanisaacs/neovim-flake";

    /*
    home computer things
    */

    lanzaboote.url = "github:nix-community/lanzaboote";
    hyprland.url = "github:hyprwm/Hyprland";
    xdg-desktop-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";
  };

  outputs = {
    self,
    rust-overlay,
    neovim-flake,
    nix-colors,
    home-manager,
    nixpkgs,
    lanzaboote,
    nur,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        (final: _: {
          neovim = neovim-configured.extendConfiguration {
            pkgs = final;
          };
        })
      ];
      config = {
        allowUnfree = true;
        permittedInsecurePackages = ["electron-25.9.0"];
      };
    };

    neovim = neovim-flake.packages.${system}.maximal;
    neovim-configured = neovim.extendConfiguration {
      inherit pkgs;
      modules = [
        {
          inherit (import ./Config/Neovim {inherit lib;}) config;
        }
      ];
    };
  in {
    packages.${system}.neovim = neovim-configured;

    nixosConfigurations = {
      lastation = lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          lanzaboote.nixosModules.lanzaboote
          ./Core/configuration.nix
        ];
      };

      wslastation = lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [./Core/configuration-wsl.nix];
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
