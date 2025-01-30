{
  pkgs,
  lib,
stable,
  inputs,
  ...
}: {
  boot = {
    uvesafb = {
      enable = true;
      gfx-mode = "1920x1080@165";
      v86d.package = stable.linuxPackages.v86d;
    };

    plymouth = {
      enable = true;
      theme = "plymouth-theme"; # "catppuccin-mocha";
      themePackages = with pkgs; [
        (catppuccin-plymouth.override {variant = "mocha";})
        (adi1090x-plymouth-themes.override {selected_themes = ["hexagon_red"];})
        (lib.gamindustri.mkPlymouthTheme {
          name = "plymouth-theme";
          description = "A cool Plymouth theme.";
          comment = "Welcome to Gamindustri!";
          image = inputs.self + /cfg/themes/cat-anime-girl/cat-anime-girl.png;
          framerate = 50;
        })
      ];
    };

    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "plymouth.use-simpledrm"
    ];

    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    consoleLogLevel = 0;
    loader.timeout = 0;
    initrd = {
      systemd.enable = true;
      verbose = false;
    };
  };
}
