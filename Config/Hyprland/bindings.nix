{theme, ...}: let
  fileManager = "kitty ranger";
  terminal = "kitty";
  browser = "firefox";
  mainMod = "SUPER";

  menu = "fuzzel -D no";
  dmenu = "fuzzel -D no --dmenu";
  print_screen = "fish ~/.diary/Config/Fish/clip.fish";
  themeDir = theme.background + "/..";
in {
  bind = [
    ###############################
    # Program keybinds.
    "${mainMod}, Q, exec, ${terminal}" # Open terminal.
    "${mainMod}, F, exec, ${browser}" # Open browser.
    "${mainMod}, E, exec, ${fileManager}" # Open the file manager.
    "${mainMod}, V, exec, cliphist list | ${dmenu} | cliphist decode | wl-copy"

    "${mainMod}, R, exec, hyprctl reload"

    ###############################
    # Administrative keybinds.
    "${mainMod}, M, exit," # Logout.
    "${mainMod}, C, killactive," # Kill selected window.
    "${mainMod} SHIFT, SPACE, togglefloating," # Make the active window float.

    ###############################
    # ElKowar's Wacky Widgets!
    "${mainMod}, F4, exec, eww open --screen 1 poweropts" # System power menu.
    "${mainMod} ALT, E, exec, eww kill"

    "${mainMod}, J, togglesplit," # ???

    "${mainMod}, SPACE, exec, ${menu}" # Fuzzel.

    "${mainMod}, V, exec, copyq menu" # Clipboard.

    "${mainMod} SHIFT, C, exec, ${print_screen}" # Print screen.

    ###############################
    # Window controls.

    # Move focus with mainMod + arrow keys.
    "${mainMod}, left, movefocus, l"
    "${mainMod}, right, movefocus, r"
    "${mainMod}, up, movefocus, u"
    "${mainMod}, down, movefocus, d"

    # Move window with mainMod + SHIFT + arrow keys.
    "${mainMod} SHIFT, left, movewindow, l"
    "${mainMod} SHIFT, right, movewindow, r"
    "${mainMod} SHIFT, up, movewindow, u"
    "${mainMod} SHIFT, down, movewindow, d"

    # Switch workspaces with mainMod + [0-9].
    "${mainMod}, 1, workspace, 1"
    "${mainMod}, 2, workspace, 2"
    "${mainMod}, 3, workspace, 3"
    "${mainMod}, 4, workspace, 4"
    "${mainMod}, 5, workspace, 5"
    "${mainMod}, 6, workspace, 6"
    "${mainMod}, 7, workspace, 7"
    "${mainMod}, 8, workspace, 8"
    "${mainMod}, 9, workspace, 9"
    "${mainMod}, 0, workspace, 10"

    # Move active window to a workspace with mainMod + SHIFT + [0-9].
    "${mainMod} SHIFT, 1, movetoworkspace, 1"
    "${mainMod} SHIFT, 2, movetoworkspace, 2"
    "${mainMod} SHIFT, 3, movetoworkspace, 3"
    "${mainMod} SHIFT, 4, movetoworkspace, 4"
    "${mainMod} SHIFT, 5, movetoworkspace, 5"
    "${mainMod} SHIFT, 6, movetoworkspace, 6"
    "${mainMod} SHIFT, 7, movetoworkspace, 7"
    "${mainMod} SHIFT, 8, movetoworkspace, 8"
    "${mainMod} SHIFT, 9, movetoworkspace, 9"
    "${mainMod} SHIFT, 0, movetoworkspace, 10"

    # Scroll through existing workspaces with mainMod + scroll.
    "${mainMod}, mouse_down, workspace, e+1"
    "${mainMod}, mouse_up, workspace, e-1"

    # Maximizing, minimizing, and fullscreening.
    ", F11, fullscreen, 0"
    "${mainMod}, equal, fullscreen, 1"

    ###############################
    # Workspaces.
    "${mainMod}, S, togglespecialworkspace, magic" # Special workspace (scratchpad).
    "${mainMod} SHIFT, S, movetoworkspace, special:magic"

    "${mainMod}, D, togglespecialworkspace, discord" # Discord workspace.
    "${mainMod} SHIFT, D, movetoworkspace, special:discord"

    "${mainMod}, O, togglespecialworkspace, overlay" # Game overlays.
    "${mainMod} SHIFT, O, movetoworkspace, special:overlay"
  ];

  bindm = [
    # Move/resize windows with mainMod + LMB/RMB and dragging.
    "${mainMod}, mouse:272, movewindow"
    "${mainMod}, mouse:273, resizewindow"
  ];
}
