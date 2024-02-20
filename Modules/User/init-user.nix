# TODO: holy shit just
# remove all of these and start
# using Folder/Default.nix
{...}: {
  imports = [
    # The specifics, baby!
    ./Hyprland/init.nix
    ./Fish/init.nix

    # Gaming and the like.
    ./Gaming/standalone.nix
    ./Gaming/launcher.nix
    ./Gaming/mod.nix
    ./Gaming/monitor.nix

    # Social media and social utilities.
    ./Social/discord.nix

    # Programming utilities and goodies.
    ./Programming/Git/init.nix
    ./Programming/vim.nix
    ./Programming/roblox

    ./Programming/node.nix
    ./Programming/rust.nix
    ./Programming/dotnet.nix
    ./Programming/lua.nix

    ./Programming/formatters.nix

    # General things, auxiliary functionalities.
    ./Miscellaneous/Terminal/init.nix
    ./Miscellaneous/Firefox/init.nix

    ./Miscellaneous/print-screen.nix
    ./Miscellaneous/electron.nix
    ./Miscellaneous/music.nix
    ./Miscellaneous/hydrus.nix
    ./Miscellaneous/audio.nix
    ./Miscellaneous/delta.nix
    ./Miscellaneous/dunst.nix
    ./Miscellaneous/font.nix
    ./Miscellaneous/clip.nix
    ./Miscellaneous/disk.nix
    ./Miscellaneous/obs.nix
    ./Miscellaneous/dir.nix
    ./Miscellaneous/qol.nix
    ./Miscellaneous/qt.nix
  ];
}
