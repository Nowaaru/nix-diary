# Edit this configuration file to define what should be installed on
# your system.	Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  kernelPackages = let
    linux_6_7_1_pkg = {
      fetchurl,
      buildLinux,
      ...
    } @ args:
      buildLinux (args
        // rec {
          version = "6.7.1";
          modDirVersion = version;

          # Latest kernel from Linus' github mirror
          src = fetchurl {
            url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.7.1.tar.xz";
            hash = "sha256-Hs/6Vo6GoiArpVM62QNLwmOpqhThiVl6lPCbOFStaMM=";
          };

          kernelPatches = [];

          # extraConfig = ''
          # '';

          extraMeta.branch = "6.7.1";
        }
        // (args.argsOverride or {}));
    linux_6_7_1 = pkgs.callPackage linux_6_7_1_pkg {};
  in
    pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_6_7_1);
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # System configuration loader.
    ../Modules/System/init.nix
  ];

  # Bootloader.
  boot = {
    inherit kernelPackages;
    bootspec.enable = true;
    initrd.kernelModules = ["nvidia"];
    blacklistedKernelModules = ["noveau"];

    loader = {
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };

  networking.hostName = "lastation"; # Define your hostname.
  # networking.wireless.enable = true;	# Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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
    nvidia = {
      modesetting.enable = true; # required
      powerManagement.enable = true; # can cause sleep settings but supposedly fixed with the newest nvidia update
      powerManagement.finegrained = false; # experimental?

      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;

      extraPackages = with pkgs; [
        intel-compute-runtime
      ];
    };

    # Enable OpenTabletDriver.
    opentabletdriver.enable = true;
    pulseaudio.enable = false;
  };
  services = {
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      videoDrivers = ["nvidia"];

      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };

      # Enable the Cinnamon and Hypr for X11.
      desktopManager.cinnamon.enable = true;
      windowManager.hypr.enable = true;

      # Configure keymap in X11

      xkb.layout = "us";
      xkb.variant = "";
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
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
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
  sound.enable = true;
  security.rtkit.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.noire = {
    isNormalUser = true;
    description = "noire";
    shell = pkgs.fish;
    extraGroups = ["networkmanager" "wheel"];
    packages = []; # managed via home-manager
  };

  # Enable flakes.
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Hyprland!
  programs.hyprland = {
    enable = true;
    portalPackage = inputs.xdg-desktop-portal-hyprland.packages."${pkgs.system}".xdg-desktop-portal-hyprland;
  };
  environment = {
    # Session variables for gaming/gamescope.
    sessionVariables = {
      # Hyprland!
      WLR_NO_HARDWARE_CURSORS = "1";
      NIX_OZONE_WL = "1";

      # Gamescope.
      WLR_RENDERER = "vulkan";
      __GL_GSYNC_ALLOWED = "1";
      __GL_VRR_ALLOWED = "0";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      LIBVA_DRIVER_NAME = "nvidia";
      WLR_RENDERER_ALLOW_SOFTWARE = "1";
      PROTON_ENABLE_NGX_UPDATER = "1";
      WLR_USE_LIBINPUT = "1";
      ENABLE_VKBASALT = "1";
      GBM_BACKEND = "nvidia-drm";
    };
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    systemPackages = with pkgs; [
      home-manager
      libsForQt5.kio-admin

      kitty
      kitty-img

      grc
      fzf
      zip
      unzip

      fishPlugins.done
      fishPlugins.fzf-fish
      fishPlugins.forgit
      fishPlugins.hydro
      fishPlugins.grc

      htop
      nvtop

      dotnet-runtime

      (nerdfonts.override {fonts = ["JetBrainsMono" "FiraMono" "FiraCode" "SpaceMono"];})
      #	wget
    ];

    # Remove unnecessary packages from Plasma 5.
    plasma5.excludePackages = with pkgs.libsForQt5; [
      konsole
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
