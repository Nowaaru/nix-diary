set -Ux SCREENSHOT_DIR $XDG_PICTURES_DIR/Screenshots
set -Ux SCREENSHOT_TOOL "slurp"

# Returns: title, initialTitle, initialClass
function window_at_pos
	# Get the mouse coordinates
	set mouse_position (hyprctl cursorpos)

	# Extract the x and y coordinates
	set mouse_x (echo $mouse_position | cut -d',' -f1)  # has an extra space, so remove it
	set mouse_y (echo $mouse_position | cut -d',' -f2 | string replace ' ' '')
	set passlist (math 2^31) "" "" ""

	# Get the list of windows and iterate through themu
	for window_info in (hyprctl clients | string join "\n" | string split -n "\n\n")
		# for some reason newline matching just doesn't work 
		# when paired with .+ or .+? in fish's string match 
		# regex. might be a flag problem but i can't
		# change those it seems 
		set title (echo -E $window_info | string match -rg "title: (.+?)\s\w+:" | string replace "\n" "")
		set class_initial (echo $window_info | string match -arg "initialClass: (.+?)\s\w+:" | string replace "\n" "")
		set title_initial (echo $window_info | string match -arg "initialTitle: (.+?)\s\w+:" | string replace "\n" "")
		set history_id  (echo $window_info | string match -arg "focusHistoryID: (-?\d+)")
		set position (echo $window_info | string match -arg "at: -?(\d+),-?(\d+)")
		set dimensions (echo $window_info | string match -arg "size: (\d+),(\d+)")
		set window_x $position[1]
		set window_y $position[2]
		set window_width $dimensions[1]
		set window_height $dimensions[2]
		
		if test -z "$window_x" -o -z "$window_y" -o -z "$window_width" -o -z "$window_height"
			echo "bad values: [$window_x] [$window_y] [$window_width] [$window_height / x,y,width,height"
			echo "none of these values should be empty"
			return 1
		end

		# echo -e result: $title [$history_id] - $window_x,$window_y @ $window_width,$window_height

		# Check if the mouse is within the window
		if test $mouse_x -ge $window_x -a \( $mouse_x -le (math $window_x + $window_width) \)
			if test $mouse_y -ge $window_y -a \( $mouse_y -le (math $window_y + $window_height) \)
				if test "$SCREENSHOT_TOOL" = "$title_initial"
					continue
				end
				if test $history_id -lt $passlist[1]
					set passlist $history_id $title $title_initial $class_initial
				end

				# echo "Mouse is inside the window with ID: $title_initial"
			end
		end

	end	

	echo -e (string join "\n" $passlist[2..(count $passlist)])
end

set -Ux __dunst_screenshot_id 85612
set date (date "+%Y.%m.%d - %R %Z")
if test ! -e $SCREENSHOT_DIR
	echo "error: screenshot directory [$SCREENSHOT_DIR] does not exist"
	return 1
end

if test ! -d $SCREENSHOT_DIR
	echo "error: screenshot directory [$SCREENSHOT_DIR] is not a directory"
	return 1
end
if test "$XDG_SESSION_TYPE" != "wayland"
	printf "ERROR: expected session type 'wayland', got '%s'" $XDG_SESSION_TYPE
end

# set -l slurp_output (slurp -d) # -d for only print dimensions
# echo (wl-paste -p)
set slurp_out (slurp -odf "%x,%y %wx%h")
set window_at_pos (window_at_pos)
set class $window_at_pos[2]
set title $window_at_pos[3]
if test -z "$title"
	set title "unknown"
end
if test -z "$class"
	set class "unknown"
end

set ext "png"
# echo $slurp_out | grim -
set filename (printf "Screenshot [%s | %s] $date" $window_at_pos[3] $window_at_pos[2])
# echo $filename
set grim_out_dir "$SCREENSHOT_DIR/$filename.$ext"
set grim_out (grim -g (echo -e $slurp_out) $grim_out_dir)
wl-copy < $grim_out_dir
dunstify -r $__dunst_screenshot_id "Screenshot saved." -i "$grim_out_dir"
return 1
