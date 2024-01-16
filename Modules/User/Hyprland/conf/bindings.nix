{ theme, ...}: 
    let 
        fileManager = "kitty ranger";
        terminal = "kitty";
        browser = "firefox";
        mainMod = "SUPER";
        # supermenu = "eww --config-dir ..."
        menu = "fuzzel -D no";

        eww =
            cmd:
                "eww -c ${theme.background + "/../eww"} " + cmd;
    in {
        bind = [
            "${mainMod}, Q, exec, ${terminal}"
            "${mainMod}, C, killactive,"
            "${mainMod}, M, exit,"
            "${mainMod}, F, exec, ${browser}"
            "${mainMod}, E, exec, ${fileManager}"
            "${mainMod} SHIFT, SPACE, togglefloating,"
            # "${mainMod}, R, exec, ${supermenu}" TODO: make logout menu with eww
            # "${mainMod}, P, pseudo," # dwindle
            "${mainMod}, P, exec, ${eww "open poweropts"}"
            "${mainMod} SHIFT, P, exec, ${eww "close-all"}"
            "${mainMod}, J, togglesplit," # dwindle"

            # Fuzzel.
            "${mainMod}, SPACE, exec, ${menu}"

            # Clipboard.
            "${mainMod}, V, exec, copyq menu"

            # Print screen.
            "${mainMod} SHIFT, C, exec, fish  ~/.diary/Config/Fish/clip.fish"

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

            # Maximizing, minimizing, and fullscreening.
            ", F11, fullscreen, 0"
            "${mainMod}, equal, fullscreen, 1"

            # Special workspace (scratchpad).
            "${mainMod}, S, togglespecialworkspace, magic"
            "${mainMod} SHIFT, S, movetoworkspace, special:magic"
        
            # Discord workspace.
            "${mainMod}, D, togglespecialworkspace, discord"
            "${mainMod} SHIFT, D, movetoworkspace, special:discord"

            # Game overlays.
            "${mainMod}, O, togglespecialworkspace, overlay"
            "${mainMod} SHIFT, O, movetoworkspace, special:overlay"

            # Scroll through existing workspaces with mainMod + scroll.
            "${mainMod}, mouse_down, workspace, e+1"
            "${mainMod}, mouse_up, workspace, e-1"
        ];

        bindm = [
            # Move/resize windows with mainMod + LMB/RMB and dragging.
            "${mainMod}, mouse:272, movewindow"
            "${mainMod}, mouse:273, resizewindow"
        ];
    }
