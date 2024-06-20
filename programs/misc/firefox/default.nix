{
  inputs,
  pkgs,
  nur,
  ...
}: {
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
          inherit inputs pkgs;
        };
      };

    profiles = {
      noire = {
        id = 0;
        name = "Noire";

        /*
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
        */

        isDefault = true;
        settings = import ./preferences.nix {
          inherit (pkgs) lib;
        };
        bookmarks = pkgs.lib.mkForce (import ./bookmarks.nix {
          inherit (pkgs) lib;
        });
        extensions = pkgs.lib.mkForce (import ./extensions.nix nur);
      };
    };

    nativeMessagingHosts = [
      pkgs.tridactyl-native
    ];
  };
}
