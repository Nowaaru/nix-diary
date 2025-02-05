{importApply, withSystem, ...} @ localFlake: args @ {
  config,
  lib,
  inputs,
  pkgs,
  self,
  ...
}: let
  usrRoot = ./.;

  specialArgs = {
    inherit (localFlake) lib;
    inherit (inputs) nix-colors;
    inherit (args) inputs nur modules;
    inherit withSystem;

    programs = import /${self}/programs (args
      // specialArgs
      // {
        inherit (localFlake.lib.traceVal pkgs) config;
        inherit withSystem;
      });
  };
in
  # TODO:
  # instead of making one flake.homeConfigurations
  # to represent every user, make flake.homeConfigurations
  # importApply the user. this will then allow
  # (withSystem "x86_64-linux" {}: ...) to be used which will
  # then expose self'.legacyPackages.default.
  # this can then be passed to specialArgs and will
  # (likely) fix home manager not building due to its use
  # of topelvel nixpkgs instead of (import nixpkgs {}).
  with localFlake.lib.gamindustri.users;
    mkHomeManager [
      # me!
      (mkUser "noire" {
        system = "x86_64-linux";
        sessionVariables = {
          EDITOR = "nvim";
        };
      })

      (mkUser "blanc" {
        system = "x86_64-linux";
        sessionVariables = {
          EDITOR = "nvim";
        };
      })

      (mkUser "vert" {
        system = "x86_64-linux";
        sessionVariables = {
          EDITOR = "nvim";
        };
      })
    ] {inherit usrRoot specialArgs;}
# {
#   imports = builtins.map (
#     v: (importApply ./${v} {
#       inherit (localFlake) withSystem;
#     })
#   ) (builtins.filter (k: k != "default.nix") (builtins.attrNames (builtins.readDir ./.)));
# }

