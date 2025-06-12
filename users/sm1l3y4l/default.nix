{ pkgs, lib, user, programs, ... }: 
{
  imports = [
    user.programs.zen

    programs.dev.nvim
    programs.gaming.minecraft
  ];

  dconf.settings = {
    "org/gnome/mutter" = {
      experimental-features = ["scale-monitor-framebuffer"];
    };
  };

  fonts.fontconfig.enable = true;

  nixpkgs.config.allowUnfree = true;
}
