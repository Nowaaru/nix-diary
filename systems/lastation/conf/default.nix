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
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports =
    [
      ./register-users.nix
      ./plymouth.nix

      ./hardware
      ./secure-boot.nix

      ../sys
    ]
    ++ (lib.gamindustri.mkModules (inputs.self + /modules));

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs;
      [
        open-fonts
        open-sans
        roboto
        roboto-mono
        roboto-serif
        migu
        noto-fonts
        google-fonts
        dejavu_fonts
        # (nerdfonts.override {fonts = ["JetBrainsMono" "FiraMono" "FiraCode" "SpaceMono"];})
      ]
      ++ (with pkgs.nerd-fonts; [jetbrains-mono fira-mono fira-code space-mono]);

    fontDir.enable = true;
  };

  # Bootloader.

  boot = {
    bootspec.enable = true;
    initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "sd_mod"];

    kernelPackages = pkgs.linuxPackages;
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
      enable = true;

      # Configure keymap in X11
      xkb.layout = "us";
      xkb.variant = "";

      # Disable XTerm
      desktopManager.xterm.enable = false;
      exportConfiguration = true;
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
    package = pkgs.nixVersions.latest;

    # Experimental settings.
    settings.experimental-features = ["nix-command" "flakes"];
  };

  # Desktop things
  services.desktopManager.plasma6.enable = true;
  programs = {
    # Noisetorch
    noisetorch.enable = true;

    dconf.enable = true;

    firejail.enable = true;

    # Hyprland!
    hyprland = {enable = true;};

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
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      insertNameservers = lib.mkForce [
        "192.168.0.165"
        "192.168.0.165:53"
        "192.168.0.165:4000"
      ];
    };
    nameservers = lib.mkForce [
      "192.168.0.165"
      "192.168.0.165:53"
      "192.168.0.165:4000"
    ];

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
