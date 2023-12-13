{builtins, config, pkgs, lib, ... }:
let
	user-init = import ./Modules/User/init-user.nix {
		inherit config pkgs lib;
	};
in
{
	imports = [
		user-init
	];
	
	# Home Manager needs a bit of information about you and the paths it should
	# manage.
	home.username = "noire";
	home.homeDirectory = "/home/noire";

	# This value determines the Home Manager release that your configuration is
	# compatible with. This helps avoid breakage when a new Home Manager release
	# introduces backwards incompatible changes.
	#
	# You should not change this value, even if you update Home Manager. If you do
	# want to update the value, then make sure to first check the Home Manager
	# release notes.
	home.stateVersion = "23.05"; # Please read the comment before changing.

# Manage the nixpkgs config for home-manager
  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "electron-25.9.0"
      ]; 
    };
  };

	# The home.packages option allows you to install Nix packages into your
	# environment.
	home.packages = with pkgs; [
		# # Adds the 'hello' command to your environment. It prints a friendly
		# # "Hello, world!" when run.
		# pkgs.hello

		# # It is sometimes useful to fine-tune packages, for example, by applying
		# # overrides. You can do that directly here, just don't forget the
		# # parentheses. Maybe you want to install Nerd Fonts with a limited number of
		# # fonts?
		# (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

		# # You can also create simple shell scripts directly inside your
		# # configuration. For example, this adds a command 'my-hello' to your
		# # environment:
		# (pkgs.writeShellScriptBin "my-hello" ''
		#	 echo "Hello, ${config.home.username}!"
		# '')
		neofetch
		notcurses
		glow
		kitty-themes
		ranger
		neovim
		page
		steam
		tldr
		mangohud
		fuzzel
		waybar
		hyprpaper
		dunst
		font-awesome
	];


	# Home Manager is pretty good at managing dotfiles. The primary way to manage
	# plain files is through 'home.file'.
	home.file = {
		# # Building this configuration will create a copy of 'dotfiles/screenrc' in
		# # the Nix store. Activating the configuration will then make '~/.screenrc' a
		# # symlink to the Nix store copy.
		# ".screenrc".source = dotfiles/screenrc;

		# # You can also set the file content immediately.
		# ".gradle/gradle.properties".text = ''
		#	 org.gradle.console=verbose
		#	 org.gradle.daemon.idletimeout=3600000
		# '';

    # This was writing a blank file to your hyprland.conf file
		# ".config/hypr/hyprland.conf".text = ''
		# '';
	};

	# You can also manage environment variables but you will have to manually
	# source
	#
	#	~/.nix-profile/etc/profile.d/hm-session-vars.sh
	#
	# or
	#
	#	/etc/profiles/per-user/noire/etc/profile.d/hm-session-vars.sh
	#
	# if you don't want to manage your shell through Home Manager.
	home.sessionVariables = {
		# EDITOR = "emacs";
		EDITOR = "nvim";
	}; 

	# Let Home Manager install and manage itself.
	programs = {
		fuzzel = {
			enable = true;
		};

		waybar = {
			enable = true;
			systemd.enable = true;
		};

		kitty = {
			enable = true;
			theme = "Everforest Dark Medium";
			shellIntegration.enableFishIntegration = true;

			font = {
				name = "SpaceMono";
				package = (pkgs.nerdfonts.override { fonts = [ "SpaceMono" ]; });
			};
			
		};

		home-manager = {
			enable = true;
		};

		fish = {
			enable = true;
			interactiveShellInit = ''
				set -U fish_greeting
				ncneofetch
				fish_vi_key_bindings
			'';
		};

		starship = {
			enable = true;
			enableTransience = true;
			enableFishIntegration = true;

			settings = {
				add_newline = true;
				format = ''
          [┌───────────────────>](bold green)
          [│](bold green)$directory$rust$package
          [└─>](bold green) 
        '';

				character = {
					success_symbol = "[➜](bold green)";
					error_symbol = "[➜](bold red)";
				};

				# package.disabled = true;
			};
		};
	};
}
