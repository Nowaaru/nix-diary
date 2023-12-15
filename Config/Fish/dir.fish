# Helper module to automatically import
# XDG declarations, which use a different
# syntax than the fish shell.

set xdg_source "$(cat ~/.config/user-dirs.dirs)"
set xdg_filtered (string replace -ar "\\#.+" "" $xdg_source)
set xdg_dirs (string match -arg '(XDG_.*)' $xdg_filtered)

if not set -q HOME
	set -U HOME ~/.
end

# looks like titties.
set titties '(.)=(.)'

# so worth it.
set fi (string replace -ar "\\." ".*" $titties)

for prop in $xdg_dirs
	set mapped (string match -arg $fi $prop | string replace -a "\"" "" | string replace -a "\$HOME" "$HOME")
	set from $mapped[1]
	set to $mapped[2]

	# echo $from $to
	set -Ux $from $to
end
