{
  config,
  lib,
  pkgs,
  ...
}: let
  moduleIndex = "gpu-screen-recorder";
  cfg = config.programs.${moduleIndex};
in
  with lib; {
    imports = [];

    options.programs.${moduleIndex} = with types; {
      notify = mkOption {
        type = submodule {
          imports = [];

          options = {
            enable = mkEnableOption "the gpu-screen-recorder ui.";
          };
        };
      };

      ui = mkOption {
        default = {};
        type = submodule {
          imports = [];

          options = {
            enable = mkEnableOption "the shadowplay-like gpu-screen-recorder overlay";
          };
        };
      };
    };

    config = let
      packages = [
        (mkIf (cfg.enable && cfg.notify.enable) (pkgs.callPackage ./packages/gpu-screen-recorder-notification.nix {}))
        (mkIf (cfg.enable && cfg.ui.enable) (pkgs.callPackage ./packages/gpu-screen-recorder-ui.nix {}))
      ];
    in
      lib.mkIf (cfg.enable)
      {
        environment.systemPackages = packages;
      };
  }
