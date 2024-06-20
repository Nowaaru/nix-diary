{
  description = "noire's nonfunctional user flake.";

  inputs = rec {
    /*
    essentials - repositories
    */
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master"; # "path:/home/noire/Documents/nix-flakes/nixpkgs";
    nurpkgs.url = "github:nix-community/NUR";

    /*
    essentials - overlays
    */
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    rust-overlay.url = "github:oxalica/rust-overlay";
    nix-colors.url = "github:misterio77/nix-colors";

    /*
    experimental modules
    */
    power-mode-nvim = {
      url = "path:/home/noire/Documents/projects/power-mode.nvim";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    /*
    libraries for this flake n stuff
    */
    nix-utils = {
      url = "github:nowaaru/nix-utils";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.home-manager.follows = "home-manager";
    };

    /*
    virtual machine test
    */
    virtio.url = "path:/home/noire/Documents/nix-flakes/libvirtd-vfio-flake";

    /*
    secrets
    */
    secrets.url = "path:/home/noire/Documents/nix-secrets";

    /*
    an anime game launcher
    */
    an-anime-game-launcher.url = "github:ezKEA/aagl-gtk-on-nix";

    /*
    home-manager
    */
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    /*
    plasma-manager
    */
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.home-manager.follows = "home-manager";
    };

    /*
    neovim
    */
    nvf.url = "github:NotAShelf/nvf";
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
    nixpkgs-stable,
    nixpkgs-unstable,
    nixpkgs-master,
    nurpkgs,
    home-manager,
    nix-colors,
    lanzaboote,
    hyprpicker,
    ...
  } @ inputs: let
    useReleaseStream = release-stream: function-that-uses-stream: (function-that-uses-stream release-stream (import release-stream {inherit system overlays config;}));
    overlays = [
      hyprpicker.overlays.default
      nurpkgs.overlay
    ];

    config = {
      allowUnfree = true;
      permittedInsecurePackages = ["electron-25.9.0"];
    };

    system = "x86_64-linux";
  in
    useReleaseStream nixpkgs-unstable (nixpkgs: pkgs: let
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
      nur = import nurpkgs {
        inherit pkgs;
        nurpkgs = import nixpkgs {
          inherit system;
        };
      };

      modules = lib.gamindustri.modules.mkModules (inputs.self + /modules);
    in {
      inherit lib;
      nixosConfigurations = let
        specialArgs = {
          inherit inputs modules;
        };
      in {
        lastation = lib.nixosSystem {
          inherit specialArgs;
          modules = [
            lanzaboote.nixosModules.lanzaboote
            inputs.an-anime-game-launcher.nixosModules.default
            ./sys/conf
          ];
        };

        leanbox = lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ./sys/wsl
          ];
        };
      };

      homeConfigurations = let
        stable = import nixpkgs-stable {
          inherit system overlays config;
        };

        master = import nixpkgs-master {
          inherit system overlays config;
        };

        unstable = import nixpkgs-unstable {
          inherit system overlays config;
        };

        usrRoot = ./usr;
        specialArgs = {
          inherit inputs nix-colors nur stable master unstable modules;
          programs = import ./programs (inputs
            // {
              inherit (pkgs) config;
              inherit inputs pkgs lib nur stable master unstable modules;
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
    });
}
