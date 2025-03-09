{
  description = "noire's nonfunctional user flake.";

  inputs = {
    /*
    release streams
    */
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-mirror.url = "github:nixos/nixpkgs/release-24.11";
    nurpkgs.url = "github:nix-community/NUR";

    /*
    essentials - overlays
    */
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    rust-overlay.url = "github:oxalica/rust-overlay";
    nix-colors.url = "github:misterio77/nix-colors";

    /*
    experimental modules - nixos
    */

    /*
    experimental modules - home manager
    */
    power-mode-nvim = {
      url = "path:/home/noire/Documents/projects/power-mode.nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-mod-manager = {
      url = "path:/home/noire/Documents/nix-flakes/nix-mod-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    umu-launcher = {
      url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl.url = "github:nix-community/nixGL";

    /*
    libraries for this flake n stuff
    */
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    nix-utils = {
      url = "github:nowaaru/nix-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    /*
    secrets
    */
    secrets.url = "path:/home/noire/Documents/nix-secrets";

    /*
    game mods
    */
    nmm-mods = {
      url = "path:/home/noire/Documents/game-mods";
      inputs = {
        nix-mod-manager.follows = "nix-mod-manager";
        home-manager.follows = "nixpkgs";
        nixpkgs.follows = "nixpkgs";
      };
    };

    /*
    an anime game launcher
    */
    an-anime-game-launcher.url = "github:ezKEA/aagl-gtk-on-nix";

    /*
    home-manager
    */
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    /*
    plasma-manager
    plasma look and feels
    plasma cursors
    */
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    plasma-theme-moe-dark = {
      url = "gitlab:jomada/moe-dark";
      flake = false;
    };

    catppuccin-cursors.url = "github:catppuccin/cursors";

    tela-icons = {
      url = "github:vinceliuice/tela-icon-theme";
      flake = false;
    };

    /*
    neovim
    */
    nvf.url = "github:NotAShelf/nvf/v0.7";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    /*
    secure boot
    */
    lanzaboote.url = "github:nix-community/lanzaboote";

    /*
    hyprland
    */
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    };

    hyprutils = {
      url = "github:hyprwm/hyprutils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hyprutils.follows = "hyprutils";
      };
    };

    hyprcursor = {
      url = "github:hyprwm/hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xdg-desktop-portal-hyprland = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hyprland.follows = "hyprland";
      };
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags = {
      url = "github:Aylur/ags";
    };

    hyprland-astal = {
      url = "path:/home/noire/Documents/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nurpkgs,
    nixpkgs-mirror,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({
      withSystem,
      flake-parts-lib,
      ...
    }: let
      inherit (flake-parts-lib) importApply;
      inherit
        (import ./overlays/extend-lib.nix
          # unsure on how to beat the infinite recursion
          # allegations
          withSystem
          (inputs // {self = ./.;})
          {}
          nixpkgs)
        lib
        ;
      overlays = import ./overlays withSystem (inputs
        // {
          inherit lib;
        });

      # = {};

      config = {
        allowUnfree = true;
      };

      modules = lib.gamindustri.modules.mkModules (inputs.self + /modules);
      _args = {
        inherit inputs importApply withSystem;
        inherit (inputs) self;
        # pkgs = import nixpkgs {
        #   system = "x86_64-linux";
        # };
        lib = builtins.trace lib.gamindustri lib;
      };

      flakeModules.users = importApply ./users _args;
      flakeModules.systems = importApply ./systems _args;
    in {
      imports = [
        inputs.flake-parts.flakeModules.flakeModules
        # inputs.home-manager.flakeModules.home-manager
        flakeModules.systems
        flakeModules.users
      ];

      systems = ["x86_64-linux" "aarch64-linux"];

      perSystem = {
        system,
        self',
        ...
      }: {
        legacyPackages = {
          default = import nixpkgs {
            inherit system overlays config;
          };

          stable = import inputs.nixpkgs-mirror {
            inherit system overlays config;
          };

          nur = import nurpkgs {
            pkgs = self'.legacyPackages.default;
            nurpkgs = import nixpkgs {
              inherit system;
            };
          };
        };
      };

      flake = {
        inherit flakeModules;
        inherit lib;

          # homeConfigurations = 
        nixosModules = modules;
      };
    });
}
