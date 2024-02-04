{
  inputs,
  config,
  pkgs,
  ...
}: let
  selfTrace = a:
    builtins.trace (builtins.toJSON a) a;
in {
  home.packages = with pkgs; [
    librewolf
  ];

  home.sessionVariables = {
    MOZ_DBUS_ENABLE = 1;
    MOZ_ENABLE_WAYLAND = 1;
  };

  programs.firefox = {
    enable = true;
    package =
      pkgs.wrapFirefox pkgs.firefox-unwrapped
      {
        extraPolicies = import ./policies.nix {
          inherit config inputs pkgs;
        };
      };
    profiles = {
      noire = {
        id = 0;
        name = "Noire";

        search = {
          default = "Google";
        };

        containers = {
          YouTube = {
            color = "red";
            icon = "fruit";
            id = 1;
          };
        };

        isDefault = true;
        settings = import ./preferences.nix {
          inherit (pkgs) lib;
        };
        bookmarks = pkgs.lib.mkForce (import ./bookmarks.nix {
          inherit (pkgs) lib;
        });
        extensions = import ./extensions.nix {
          inherit config;
        };
      };
    };
  };
}
