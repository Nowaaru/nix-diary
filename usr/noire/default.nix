# TODO: holy shit just
# remove all of these and start
# using Folder/Default.nix
{programs, ...}: let
  selfTrace = w: builtins.trace w w;
in {
  imports = [
    # Managing the desktop.
    programs.desktop.hyprland.all

    # Developer goodies.
    programs.dev.fish
    programs.dev.dotnet
    programs.dev.formatters
    programs.dev.lua
    programs.dev.node
    programs.dev.nvim
    programs.dev.roblox
    programs.dev.rust

    programs.dev.git.lazygit
    programs.dev.git.all

    # Gaming and the like.
    programs.gaming.osu

    # Social media and social utilities.
    programs.social.discord

    # General things, auxiliary functionalities.
    programs.misc.qol.night-light
    programs.misc.qol.kdenlive

    programs.misc.terminal.all
    programs.misc.firefox.all

    programs.misc.font
    programs.misc.dunst
    programs.misc.print-screen

    programs.misc.delta

    programs.misc.video
    programs.misc.audio
    programs.misc.clip
    programs.misc.disk
    programs.misc.dir

    programs.misc.portals
    programs.misc.hydrus
    programs.misc.obs
    programs.misc.qt

    # Skate through the world, there's no one way to grind...
    programs.music.mixers.ncpamixer
    programs.music.players.spotify
  ];

  nixpkgs.config.allowUnfree = true;

  # Enable my mod manager.
  #  programs.nix-mod-manager = {
  #  enable = true;
  #  clients = {
  #    monster-hunter-world = let
  #      inherit (inputs.nnmm.lib.nnmm) mkLocalMod fetchers providers;
  #      inherit (inputs.home-manager.lib.hm) dag;
  #    in
  #     with inputs.mods.monster-hunter-world; {
  #        enable = true;
  #        rootPath = ".local/share/Steam/steamapps/common/Monster Hunter World";
  #        deploymentType = "loose";
  #
  #        modsPath = ".";
  #        binaryPath = ".";
  #
  #        binaryMods = binary;
  #
  #        mods = lib.mkMerge [
  #          efx
  #          # npc
  #
  #          # nsfw
  #          sfw
  #          misc
  #          # misc-nsfw
  #          # monster
  #        ];
  #      };
  #  };
  # };
}