{
  description = "noire's nonfunctional user flake.";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # 9aa6de663bcf2ade2a79d88a2d527c2a9986631c
    nixpkgs-mongodb-pin.url = "github:NixOS/nixpkgs/d9e28880025f124abe4f79dc99500d7ec155d55d";
    # nixpkgs-chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nurpkgs.url = "github:nix-community/NUR";

    /*
    essentials - overlays
    */
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    rust-overlay.url = "github:oxalica/rust-overlay";
    nix-colors.url = "github:misterio77/nix-colors";

    /*
    experimental modules - home manager
    */
    power-mode-nvim = {
      url = "path:/home/noire/Documents/projects/power-mode.nvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-mod-manager = {
      url = "path:/home/noire/Documents/nix-flakes/nix-mod-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    umu-launcher = {
      url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixgl.url = "github:nix-community/nixGL";

    /*
    libraries for this flake n stuff
    */
    nix-utils = {
      url = "github:nowaaru/nix-utils";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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
        home-manager.follows = "nixpkgs-unstable";
        nixpkgs.follows = "nixpkgs-unstable";
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
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    /*
    plasma-manager
    plasma look and feels
    plasma cursors
    */
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        hyprutils.follows = "hyprutils";
      };
    };

    hyprcursor = {
      url = "github:hyprwm/hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    xdg-desktop-portal-hyprland = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        hyprland.follows = "hyprland";
      };
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    ags = {
      url = "github:Aylur/ags";
    };

    hyprland-astal = {
      url = "path:/home/noire/Documents/hyprland";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {
    nixpkgs-unstable,
    nurpkgs,
    home-manager,
    nix-colors,
    lanzaboote,
    hyprpicker,
    nixpkgs-mongodb-pin,
    nixgl,
    ...
  } @ inputs: let
    useReleaseStream = release-stream: function-that-uses-stream: (function-that-uses-stream release-stream (import release-stream {inherit system overlays config;}));
    overlays = [
      hyprpicker.overlays.default
      nurpkgs.overlays.default
      nixgl.overlay

      (_: super: {
        inherit
          ((import nixpkgs-mongodb-pin {
            inherit system;
            config.allowUnfreePredicate = pkg: "mongodb" == (super.lib.getName pkg);
          }))
          mongodb
          ;
      })
      (_: super: {
        lib = super.lib.extend (_: prev:
          # home-manager.lib //
            prev
            // {
              # add lib.hm to my lib
              inherit (home-manager.lib) hm;

              # add lib.nnmm to lib
              inherit (inputs.nix-mod-manager.lib) nnmm;

              gamindustri = import (inputs.self + /lib) (inputs
                // {
                  pkgs = super;
                  lib =
                    prev
                    // home-manager.lib
                    // (
                      if super.config ? "lib"
                      then super.config.lib
                      else {}
                    );
                });
            });
        # override with
      })
    ];

    config = {
      allowUnfree = true;
    };

    system = "x86_64-linux";
  in
    useReleaseStream nixpkgs-unstable (nixpkgs: pkgs: let
      inherit (pkgs) lib;

      nur = import nurpkgs {
        inherit pkgs;
        nurpkgs = import nixpkgs {
          inherit system;
        };
      };

      stable = import inputs.nixpkgs-stable {
        inherit system overlays config;
      };

      unstable = import inputs.nixpkgs-unstable {
        inherit system overlays config;
      };

      modules = lib.gamindustri.modules.mkModules (inputs.self + /modules);
    in {
      inherit pkgs lib;

      nixosConfigurations = let
        specialArgs = {
          inherit stable unstable inputs modules lib;
        };
      in {
        lastation = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            lanzaboote.nixosModules.lanzaboote
            inputs.an-anime-game-launcher.nixosModules.default
              # inputs.nixpkgs-chaotic.nixosModules.default
            ./sys/conf
          ];
        };

        leanbox = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ./sys/wsl
          ];
        };
      };

      homeConfigurations = let
        usrRoot = ./usr;
        specialArgs = {
          inherit inputs lib nix-colors nur stable unstable modules;

          programs = import ./programs (inputs
            // {
              inherit (pkgs) config;
              inherit inputs pkgs lib nur stable unstable modules;
            });
        };
      in
        with lib.gamindustri.users;
          mkHomeManager [
            # me!
            (mkUser "noire" {
              /*
              unsure why hardware.openrazer.users doesn't work?
              */
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
