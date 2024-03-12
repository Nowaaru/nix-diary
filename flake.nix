# please no unnecessary PRs
# at this point you probably wont even break it
# but LORD i don't want to deal with the confusion
# if it does break
# Pain
{
  description = "noire's nonfunctional user flake.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-colors.url = "github:misterio77/nix-colors";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    rust-overlay.url = "github:oxalica/rust-overlay";
    nur.url = "github:nix-community/NUR";

    # power-mode-nvim-test = {
    #   url = "path:/home/noire/Documents/power-mode.nvim";
    #   flake = true;
    # };

    hyprrpc = {
      url = "github:nowaaru/hyprrpc";
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
    nixos-wsl,
    # power-mode-nvim-test,
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
        # power-mode-nvim-test.overlays.default
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
          {
            nixpkgs.overlays = [
              # (import ./Shims/wlroots-explicit-sync-overlay {
              #   inherit pkgs lib;
              # })
            ];
          }
          ./Core/configuration.nix
        ];
      };

      leanbox = lib.nixosSystem {
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
        neovim-flake.homeManagerModules.default
        ./home.nix
      ];
    };

    /*
    bare-bones wsl config
    */
    homeConfigurations."leanbox" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./home-wsl.nix
      ];
      extraSpecialArgs = {inherit inputs nix-colors;};
    };
  };
}
