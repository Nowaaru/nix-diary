# TODO: holy shit just
# remove all of these and start
# using Folder/Default.nix
{
  config,
  configure,
  programs,
  lib,
  user,
  ...
}: {
  imports = [
    # Managing the desktop.
    programs.desktop.hyprland.cursors.macos
    programs.desktop.hyprland.desktop

    programs.desktop.hyprland.fuzzel
    programs.desktop.hyprland.ags

    # Developer goodies.
    programs.dev.formatters.dprint

    programs.dev.langs.javascript.typescript
    programs.dev.langs.javascript.node
    programs.dev.langs.javascript.bun

    programs.dev.langs.dotnet
    programs.dev.langs.rust
    programs.dev.langs.lua

    programs.dev.nvim

    programs.dev.git
    programs.dev.lazygit

    # Gaming and the like.
    programs.gaming.minecraft
    programs.gaming.lutris
    programs.gaming.steam
    programs.gaming.osu

    # Social media and social utilities.
    programs.social.discord.vesktop

    # General things, auxiliary functionalities.
    programs.misc.qol.night-light
    programs.misc.qol.kdenlive
    programs.misc.qol.obsidian
    programs.misc.bitwarden

    programs.misc.terminal.all

    programs.misc.dunst
    programs.misc.print-screen

    programs.misc.video
    programs.misc.audio
    programs.misc.clip
    programs.misc.disk
    programs.misc.dir

    programs.misc.portals
    programs.misc.obs

    # Skate through the world, there's no one way to grind...
    programs.entertainment.music.mixers.ncpamixer
    programs.entertainment.music.players.spotify
    programs.entertainment.jellyfin

    # Games by those who rule the world.
    # user.programs.an-anime-team.anime-game
    # user.programs.an-anime-team.honkers-railway
    # user.programs.an-anime-team.honkers

    # Desktop
     user.programs.plasma

    # Images
    user.programs.hydrus

    # Browsers
    # user.programs.floorp.all
    user.programs.brave.all

    # Applications/Misc
    user.programs.blender
    user.programs.r2modman
    user.programs.nmm
    user.programs.rojo
    user.programs.umu

    # Multi-GPU
    user.programs.nixgl

    # UI
    user.programs.awesome
    user.programs.gimp
    user.programs.piper
    user.programs.qt
    user.programs.fonts.nerdfont.all
  ];

  dconf.settings = {
    "org/gnome/mutter" = {
      experimental-features = ["scale-monitor-framebuffer"];
    };
  };



  fonts.fontconfig.enable = true;

  nixpkgs.config.allowUnfree = true;

  xdg = configure "xdg";

  i18n = configure "ime";
}
