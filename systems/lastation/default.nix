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

      modules = [
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.home-manager.nixosModules.home-manager
        /*
        readonly pkgs
        */
        {
          imports = [
            inputs.nixpkgs.nixosModules.readOnlyPkgs
          ];

          nixpkgs.pkgs = pkgs.lib.mkForce pkgs;
        }

        ./conf
      ];
    });
}
