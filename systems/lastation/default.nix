toplevel @ {
  withSystem,
  inputs,
  ...
}: _: {
  flake.nixosConfigurations.lastation = withSystem "x86_64-linux" ({self', ...}: let
    pkgs = self'.legacyPackages.default;
    specialArgs = {
      inherit (self'.legacyPackages) nur unstable stable;
      inherit (pkgs) lib;
      inherit inputs;
    };
  in
    inputs.nixpkgs.lib.nixosSystem {
      inherit specialArgs;
      inherit (pkgs) lib;

      modules = with inputs; [
        lanzaboote.nixosModules.lanzaboote
        home-manager.nixosModules.home-manager
        # nix-ld.nixosModules.nix-ld
        /*
        readonly pkgs
        */
        {
          imports = [
            nixpkgs.nixosModules.readOnlyPkgs
          ];

          nixpkgs.pkgs = pkgs.lib.mkForce pkgs;
        }

        ./conf
      ];
    });
}
