# Edit this configuration file to define what should be installed on
# your system.	Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
/*
TODO: To allow other users to edit their home-manager
configuration, symlink their ~/.diary/usr/{usrName} directory
to their own ~/.diary folder and rescind permissions
for directories above their own dedicated edirectory.
*/
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware.nix
    inputs.virtio.outputs.x86_64-linux

    # System configuration loader.
    ../.

    # Users
    ./register-users.nix
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      open-fonts
      open-sans
      roboto
      roboto-mono
      roboto-serif
      migu
      noto-fonts
      google-fonts
      dejavu_fonts
      (nerdfonts.override {fonts = ["JetBrainsMono" "FiraMono" "FiraCode" "SpaceMono"];})
    ];

    fontDir.enable = true;
  };

  # Bootloader.
  boot = {
    bootspec.enable = true;
    kernelModules = ["nvidia"];
    blacklistedKernelModules = ["nouveau"];
    kernelPackages = pkgs.linuxPackages;

    loader = {
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    # Plymouth and Friends.
    plymouth = {
      enable = false;
      theme = "hexagon_red";
      themePackages = [(pkgs.adi1090x-plymouth-themes.override {selected_themes = ["hexagon_red"];})];
    };

    kernelParams = [
      "amdgpu.ppfeaturemask=0xffffffff"
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
      "nvidia.NVreg_EnableGpuFirmware=0"
    ];

    # consoleLogLevel = 0;
    # kernelParams = [
    #   "quiet"
    #   "splash"
    #   "boot.shell_on_fail"
    #   "nosgx"
    #   "loglevel=3"
    #   "rd.systemd.show_status=false"
    #   "rd.udev.log_level=3"
    #   "udev.log_priority=3"
    # ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    # loader.timeout = 0;
    # initrd = {
    #   systemd.enable = true;
    #   verbose = true;
    # };
  };

  # Set your time zone.
  time.timeZone = "America/Phoenix";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  hardware = {
    # Hardware setup.
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;

    nvidia = {
      modesetting.enable = true; # required
      powerManagement.enable = true; # can cause sleep problems but supposedly fixed with the newest nvidia update
      powerManagement.finegrained = false;

      open = lib.mkForce false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };

    graphics = {
      enable = lib.mkDefault true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        intel-compute-runtime
      ];
    };

    # Enable OpenTabletDriver.
    opentabletdriver.enable = true;
  };

  services = {
    kanata = {
      enable = true;
      keyboards.default = {
        extraDefCfg = ''
          concurrent-tap-hold yes
        '';

        config = ''
          (defsrc
                                 bspc
                   w          [ ] \
            caps a s d      ; '
                 ralt  spc
          )
          ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


          (deflayer default
                                    _
                     _          _ _ _
            @cycle _ _ _      _ _
                      _  _
          )

          (deflayer unib2
                                    lalt
                     1             b c d
            @cycle 2 3 4         a g
                      bspc  spc
          )

          ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

          (defalias
            to-unib2 (layer-switch unib2)
            to-default (layer-switch default))

          (defalias
            cycle (tap-dance 200 (caps @to-default @to-unib2)))
        '';
      };
    };

    displayManager.sddm = {
      enable = true;
      wayland = {
        enable = true;
      };

      settings = {};
    };

    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      videoDrivers = ["nvidia"];

      # Configure keymap in X11
      xkb.layout = "us";
      xkb.variant = "";

      # Disable XTerm
      desktopManager.xterm.enable = false;
      windowManager.awesome.enable = true;
    };

    # Configure keymap in Wayland.
    keyd = {
      enable = true;
      keyboards = {
        apex7 = {
          ids = ["1038:1618"];
          settings = {
            main = {
              "volumeup up" = "mwheelup";
              "volumedown up" = "mwheeldown";
            };
          };
        };
      };
    };

    # Enable CUPS to print documents.
    printing.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      audio.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    openssh.enable = true;

    # Enable Flatpak sandboxing.
    flatpak.enable = true;
  };

  # Enable sound with pipewire.
  security = {
    rtkit.enable = true;
    wrappers = {
      firejail = {
        source = "${pkgs.firejail.out}/bin/firejail";
      };
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.noire = {
  #   isNormalUser = true;
  #   description = "noire";
  #   shell = pkgs.fish;
  #   extraGroups = ["networkmanager" "wheel" "libvirtd"];
  #   packages = []; # managed via home-manager
  # };
  # users.users = import ./register-users.nix args;
  nix = {
    # Enable flakes.

    # Disabled in favor of nh.
    # gc = {
    #   automatic = true;
    #   randomizedDelaySec = "14m";
    #   options = "--delete-older-than 10d";
    # };

    # I am insane.
    package = pkgs.nixVersions.nix_2_21;

    # Experimental settings.
    settings.experimental-features = ["nix-command" "flakes"];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Desktop things
  services.desktopManager.plasma6.enable = true;
  programs = {
    # Noisetorch
    noisetorch.enable = true;

    dconf.enable = true;

    firejail.enable = true;

    # Hyprland!
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage =
        inputs
        .xdg-desktop-portal-hyprland
        .packages
        .${pkgs.system}
        .xdg-desktop-portal-hyprland;
    };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    nh = {
      enable = true;
      flake = "/home/noire/.diary"; # TODO: change to somewhere in /etc/ maybe? i dunno

      clean = {
        enable = true;
        dates = "weekly";
        extraArgs = "";
      };
    };
  };

  environment = {
    # Session variables for gaming/gamescope.
    sessionVariables = {
      # Hyprland!
      WLR_NO_HARDWARE_CURSORS = lib.mkDefault "1";
      NIX_OZONE_WL = lib.mkDefault "1";

      # Gamescope.
      # WLR_RENDERER = lib.mkDefault "vulkan";
      # __GL_GSYNC_ALLOWED = lib.mkDefault "1";
      # __GL_VRR_ALLOWED = lib.mkDefault "0";
      # __GLX_VENDOR_LIBRARY_NAME = lib.mkDefault "nvidia";
      # LIBVA_DRIVER_NAME = lib.mkDefault "nvidia";
      # WLR_RENDERER_ALLOW_SOFTWARE = lib.mkDefault "1";
      # PROTON_ENABLE_NGX_UPDATER = lib.mkDefault "1";
      # WLR_USE_LIBINPUT = lib.mkDefault "1";
      # ENABLE_VKBASALT = lib.mkDefault "1";
      # GBM_BACKEND = lib.mkDefault "nvidia-drm";

      TERMINAL = lib.mkDefault "kitty";
    };

    systemPackages = with pkgs; [
      # test, for now.
      (pkgs.writeTextDir "share/libratbag/logitech-g102-g203.device" ''
        # G102, G103 and G203 (USB)
        [Device]
        Name=Logitech Gaming Mouse G102/G103/G203
        DeviceMatch=usb:046d:c084;usb:046d:c092;usb:046d:c09d
        Driver=hidpp20
        LedTypes=logo;side;
      '')

      corectrl
      adwaita-icon-theme
      libsForQt5.kio-admin

      grc
      fzf
      zip
      unzip
      unrar

      fishPlugins.done
      fishPlugins.forgit
      fishPlugins.hydro
      fishPlugins.grc

      dotnet-runtime
      nix-du
    ];
  };

  networking = {
    hostName = "lastation"; # Define your hostname.
    mihoyo-telemetry.block = true;

    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [25565];
      allowedTCPPortRanges = [
        {
          from = 34872;
          to = 34876;
        }
      ];
      allowedUDPPorts = [];
    };
  };

  system.stateVersion = "23.11"; # Did you read the comment?
  virtualisation.waydroid.enable = true;
}
