args @ {
  lib,
  inputs,
  ...
}: let
  usrRoot = ./.;

  specialArgs = {
    inherit (inputs) nix-colors;
    inherit (args) inputs nur modules;
    inherit (lib) withSystem;
  };
in
  with lib.gamindustri.users;
    lib.traceVal (mkHomeManager [
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

      # (mkUser "vert" {
      #   system = "x86_64-linux";
      #   sessionVariables = {
      #     EDITOR = "nvim";
      #   };
      # })
    ] {inherit usrRoot specialArgs;})
