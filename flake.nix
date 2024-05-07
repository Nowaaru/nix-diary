# please no unnecessary PRs
# at this point you probably wont even break it
# but LORD i don't want to deal with the confusion
# if it does break
# Pain
{
  description = "noire's nonfunctional user flake.";

  inputs = {
    /*
    essentials
    */
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-colors.url = "github:misterio77/nix-colors";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    rust-overlay.url = "github:oxalica/rust-overlay";
    nur.url = "github:nix-community/NUR";
    mopidy.url = "path:/home/noire/Documents/nix-secrets/mopidy";

    /*
    experimental modules
    */
    power-mode-nvim = {
      url = "path:/home/noire/Documents/projects/power-mode.nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    /*
    libraries for this flake n stuff
    */
    nix-utils = {
      url = "github:nowaaru/nix-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    /*
    agenix
    */
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = ""; # please god i pray that not a single mac user sees this config option
    };

    /*
    home-manager
    */
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    /*
    plasma-manager
    */
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    /*
    neovim
    */
    nvf.url = "path:/home/noire/Documents/nix-flakes/nvf";
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
    nixpkgs,
    home-manager,
    nix-colors,
    lanzaboote,
    hyprpicker,
    agenix,
    nur,
    ...
  } @ inputs: let
    lib = nixpkgs.lib; #.extend (final: _: (import (inputs.self + /lib) final) // home-manager.lib);
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
    /*
    lol
    */
  in {
    inherit lib;
    nixosConfigurations = let
      specialArgs = {inherit inputs;};
    in {
      lastation = lib.nixosSystem {
        inherit specialArgs;
        modules = [
          lanzaboote.nixosModules.lanzaboote
          agenix.nixosModules.default
          {
            nixpkgs.overlays = [
              # (import sys/overlay/wlroots-explicit-sync-overlay {
              #   inherit pkgs lib;
              # })
            ];
          }
          ./sys/conf
        ];
      };

      leanbox = lib.nixosSystem {
        inherit specialArgs;
        modules = [
          agenix.nixosModules.default
          ./sys/wsl
        ];
      };
    };

    homeConfigurations = let
      extraSpecialArgs = {
        inherit inputs nix-colors;
        programs = import ./programs {inherit lib inputs;};
      };
    in {
      "noire" =
        home-manager.lib.homeManagerConfiguration
        {
          inherit pkgs extraSpecialArgs;
          modules = [
            nur.nixosModules.nur
            ./usr/noire
          ];
        };

      /*
      bare-bones wsl config
      */
      "vert" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs extraSpecialArgs;
        modules = [
          ./wsl
        ];
      };
    };
  };
}
