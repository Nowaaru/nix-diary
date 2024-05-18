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
    secrets.url = "path:/home/noire/Documents/nix-secrets";
    nurpkgs.url = "github:nix-community/NUR";

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

    virtio.url = "path:/home/noire/Documents/nix-flakes/libvirtd-vfio-flake";

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
    nurpkgs,
    home-manager,
    nix-colors,
    lanzaboote,
    hyprpicker,
    agenix,
    ...
  } @ inputs: let
    lib =
      nixpkgs.lib.extend (_: prev:
        prev
        // {
          gamindustri = import (inputs.self + /lib) (inputs
            // {
              inherit pkgs;
              lib = prev // home-manager.lib;
            });
        })
      // home-manager.lib;
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        hyprpicker.overlays.default
        nurpkgs.overlay
      ];
      config = {
        allowUnfree = true;
        permittedInsecurePackages = ["electron-25.9.0"];
      };
    };

    nur = import nurpkgs {
      inherit pkgs;
      nurpkgs = import nixpkgs {
        inherit system;
      };
    };
  in {
    inherit lib;
    nixosConfigurations = let
      specialArgs = {inherit inputs;};
    in {
      lastation = lib.nixosSystem {
        inherit specialArgs;
        modules = [
          lanzaboote.nixosModules.lanzaboote
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
      usrRoot = ./usr;
      specialArgs = {
        inherit inputs nix-colors nur;
        programs = import ./programs (inputs
          // {
            inherit (pkgs) config;
            inherit inputs pkgs lib nur;
          });
      };
    in
      with lib.gamindustri.users;
        mkHomeManager [
          # me!
          (mkUser "noire" {
            sessionVariables = {
              EDITOR = "nvim";
            };
          })

          (mkUser "vert" {
            sessionVariables = {
              EDITOR = "nvim";
            };
          })

          (mkUser "neptune" {
            sessionVariables = {
              EDITOR = "nvim";
            };
          })
        ] {inherit usrRoot specialArgs;};
  };
}
