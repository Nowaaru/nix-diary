# Initialize auxiliary paths.
set -Ux CONFIG $DIARY/cfg

set -Ux USER_MODULES $DIARY/usr
set -Ux SYSTEM_MODULES $DIARY/sys
set -Ux LIBRARY_MODULES $DIARY/lib

# Git.
source $CONFIG/fish/git.fish
