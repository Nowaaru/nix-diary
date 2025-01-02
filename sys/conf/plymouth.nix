{pkgs, ...}: {
  boot = {
    plymouth = {
      enable = true;
      theme = "hexagon_red";
      themePackages = [(pkgs.adi1090x-plymouth-themes.override {selected_themes = ["hexagon_red"];})];
    };

    consoleLogLevel = 0;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "nosgx"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];

    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;
    initrd = {
      systemd.enable = true;
      verbose = true;
    };
  };
}
