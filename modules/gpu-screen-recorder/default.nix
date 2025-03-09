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

            keymaps = {
              register = mkEnableOption "keymap registration for Wayland compositors";
            };

            autostart = {
              enable = mkEnableOption "automatically starting the overlay service";
            };
          };
        };
      };
    };

    config = let
      gsr-ui =
        pkgs.callPackage ./packages/gpu-screen-recorder-ui.nix {};

      gsr-notify = pkgs.callPackage ./packages/gpu-screen-recorder-notification.nix {};

      packages = [
        (mkIf (cfg.enable && cfg.notify.enable) gsr-notify)
        (mkIf (cfg.enable && cfg.ui.enable) gsr-ui)

        (pkgs.runCommand "gpu-screen-recorder" {
            nativeBuildInputs = [pkgs.makeWrapper];
          } ''
            mkdir -p $out/bin
            makeWrapper ${pkgs.gpu-screen-recorder}/bin/gpu-screen-recorder $out/bin/gpu-screen-recorder \
              --prefix LD_LIBRARY_PATH : ${pkgs.libglvnd}/lib \
              --prefix LD_LIBRARY_PATH : ${config.boot.kernelPackages.nvidia_x11}/lib
          '')
      ];
    in
      lib.mkMerge [
        (lib.mkIf (cfg.enable)
          {
            environment.systemPackages = packages;

            systemd.user.services.start-gsr = {
              wantedBy = ["multi-user.target" "graphical-session.target"];
              after = ["graphical-session.target"];
              serviceConfig = {
                ExecStart = "systemctl start --now --user gpu-screen-recorder.service";
              };
            };

            security.wrappers."gsr-kms-server" = lib.mkForce {
              owner = "root";
              group = "root";
              capabilities = "cap_sys_admin+ep";
              source = "${cfg.package}/gsr-kms-server";
            };
          })

        (lib.mkIf (cfg.ui.autostart.enable) {
          systemd.user.services.start-gsr-ui = {
            wantedBy = ["multi-user.target" "graphical-session.target" "start-gsr.target"];
            after = ["graphical-session.target" "start-gsr.target"];
            serviceConfig = {
              ExecStart = "systemctl start --now --user gpu-screen-recorder-ui.service";
            };
          };
        })
        (lib.mkIf (cfg.ui.keymaps.register) {
          systemd.user.services.start-gsr-ui-keymaps = {
            wantedBy = ["multi-user.target" "graphical-session.target" "start-gsr-ui.target"];
            after = ["graphical-session.target" "start-gsr.target" "start-gsr-ui.target"];
            serviceConfig = {
              ExecStart = "${gsr-ui}/gsr-ui virtual keyboard";
            };
          };
        })
      ];
  }
