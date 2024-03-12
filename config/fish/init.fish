# Initialize auxiliary paths.
set -Ux CONFIG $DIARY/config
set -Ux MODULES $DIARY/modules

set -Ux USER_MODULES $MODULES/User
set -Ux SYSTEM_MODULES $MODULES/System

# Git.
source $CONFIG/fish/git.fish
