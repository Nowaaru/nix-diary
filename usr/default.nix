# TODO: holy shit just
# remove all of these and start
# using Folder/Default.nix
{ inputs, lib, ...}: {
  imports = [
    # Managing the desktop.
    ./desktop

    # Managing the fish shell.
    ./fish

    # Gaming and the like.
    ./gaming

    # Social media and social utilities.
    ./social

    # Programming utilities and goodies.
    ./dev

    # General things, auxiliary functionalities.
    ./misc

    # Skate through the world, there's no one way to grind...
    ./music
  ];

  home = {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    username = "noire";
    homeDirectory = "/home/noire";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "24.05"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    packages = [];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file = {};

    sessionVariables = {
      # EDITOR = "emacs";
      EDITOR = "nvim";
    };
  };

  # services.mpd = {
  #   # Enable the Music Player Daemon.
  #   user = home.username;
  #
  #   enable = true;
  #   musicDirectory = home.homeDirectory + "/Music";
  #   extraConfig = ''
  #   '';
  # };

  # systemd.services.mpd.environment = {
  #   # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
  #   XDG_RUNTIME_DIR = "/run/user/${toString config.users.users.userRunningPipeWire.uid}"; # User-id must match above user. MPD will look inside this directory for the PipeWire socket.
  # };

  # Enable my mod manager.
  programs.nix-mod-manager = {
    enable = true;
    clients = {
      monster-hunter-world = let
        inherit (inputs.nnmm.lib.nnmm) mkLocalMod fetchers providers;
        inherit (inputs.home-manager.lib.hm) dag;

        nexus-provider =
          providers.nexus.mkNexus "IpfE8TXtgVv8Rs8AoSKzsDPkWyodV1Gwylk1Mm2XRXk=--vzpSxcA0LprYJeFl--1wcrpzP2C72Txa8S3l28uQ==";

        nexus-game-test = nexus-provider.useGame "monsterhunterworld";

        nexus-provider-test = nexus-game-test.fetchNexus {
          mod-id = 112;
          file-id = 7364;
        };
      in
        with inputs.mods.monster-hunter-world; {
          enable = true;
          rootPath = ".local/share/Steam/steamapps/common/Monster Hunter World";
          deploymentType = "loose";

          modsPath = ".";
          binaryPath = ".";

          binaryMods = binary;

          mods = lib.mkMerge [
            efx
            npc

            # nsfw
            sfw
            misc
            # misc-nsfw
          ];
        };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
