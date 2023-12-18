{ pkgs, ... }: {
	programs.waybar = {
		enable = true;
		settings = {
			mainBar = {
				layer = "top";
				position = "top";
				height = 30;
				spacing = 4;
				output = [
				"DP-1"
				];
				modules-left = [ "hyprland/workspaces" "wlr/taskbar" ];
				modules-center = [ "hyprland/window" ];
				modules-right = [ "cpu" "memory" "pulseaudio" "clock" "tray" ];
				"cpu" = {
					format = "{usage}% ";
					tooltip = false;
				};
				"memory" = {
					format = "{}% ";
				};
				"pulseaudio" = {
					format = "{volume}% {icon} {format_source}";
					format-bluetooth = "{volume}% {icon} {format_source}";
					format-bluetooth-muted = " {icon} {format_source}";
					format-muted = " {format_source}";
					format-source = "{volume}% ";
					format-source-muted = "";
					format-icons = {
							headphone = "";
							hands-free = "";
							headset = "";
							phone = "";
							portable = "";
							car = "";
							default = ["" "" ""];
					};
					on-click = "pavucontrol";
				};
				"clock" = {
					tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
					format-alt = "{:%Y-%m-%d}";
				};
			};
		};
	};
}
