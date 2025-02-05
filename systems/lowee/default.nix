toplevel @ {
  withSystem,
  inputs,
  ...
}: {
  self,
  system,
  ...
}: {
  flake.nixosConfigurations.lowee = withSystem "aarch64-linux" ({
    system,
    self',
    ...
  }: let
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
        /*
        readonly pkgs
        */
        {
          imports = [
            inputs.nixpkgs.nixosModules.readOnlyPkgs
          ];

          nixpkgs.pkgs = pkgs.lib.mkForce pkgs;
        }

        ./sys/configuration.nix
        inputs.home-manager.nixosModules.home-manager
      ];
    });
}
