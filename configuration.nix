# Edit this configuration file to define what should be installed on
# your system.	Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{
	imports =
		[ # Include the results of the hardware scan.
			./hardware-configuration.nix
			# XWayland patches.
			./Shims/XWayland/xwayland.nix
			# System configuration loader.
			./Modules/System/init.nix
		];

	# Bootloader.
	boot = {
		bootspec.enable = true;

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

	# Hardware setup.
	hardware.nvidia = {
		modesetting.enable = true; # required
		powerManagement.enable = true; # can cause sleep settings but supposedly fixed with the newest nvidia update
		powerManagement.finegrained = false; # experimental?

		open = false;
		nvidiaSettings = true;
		package = config.boot.kernelPackages.nvidiaPackages.stable;
	};

	hardware.opengl = {
		enable = true;
		driSupport = true;
		driSupport32Bit = true;
	};

	# Enable the X11 windowing system.
	services.xserver.enable = true;
	services.xserver.videoDrivers = ["nvidia"];

	# Enable the KDE Plasma Desktop Environment.
	services.xserver.displayManager.sddm.enable = true;
	services.xserver.desktopManager.plasma5.enable = true;

	# Configure keymap in X11
	services.xserver = {
		layout = "us";
		xkbVariant = "";
	};

	# Enable CUPS to print documents.
	services.printing.enable = true;

	# Enable sound with pipewire.
	sound.enable = true;
	hardware.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire = {
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

	nixpkgs = {
		config = {
			allowUnfree = true;
			permittedInsecurePackages = [
				"electron-25.9.0"
			]; 
		};
	};

	# Enable touchpad support (enabled default in most desktopManager).
	# services.xserver.libinput.enable = true;

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.noire = {
		isNormalUser = true;
		description = "noire";
		shell=pkgs.fish;
		extraGroups = [ "networkmanager" "wheel" ];
		packages = with pkgs; [
			discord
			discordo
			firefox
			kate
		#	thunderbird
		];
	};

	# Enable flakes.
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	# Allow unfree packages
	# nixpkgs.config.allowUnfree = true;

	# Session variables for gaming/gamescope.
	environment.sessionVariables = {
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
	environment.systemPackages = with pkgs; [
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

		(nerdfonts.override { fonts = [ "JetBrainsMono" "FiraMono" "FiraCode" "SpaceMono" ]; })
	#	wget
	];

	# Remove unnecessary packages from Plasma 5.
	environment.plasma5.excludePackages = with pkgs.libsForQt5; [
		konsole
	];


	# Some programs need SUID wrappers, can be configured further or are
	# started in user sessions.
	# programs.mtr.enable = true;
	programs.gnupg.agent = {
		enable = true;
		enableSSHSupport = true;
	};

	programs.hyprland = { 
		enable = true;
		enableNvidiaPatches = true;
	};

	# List services that you want to enable:

	# Enable the OpenSSH daemon.
	services.openssh.enable = true;

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
