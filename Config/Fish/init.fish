# Initialize auxiliary paths.
set -Ux CONFIG $DIARY/Config
set -Ux MODULES $DIARY/Modules

set -Ux USER_MODULES $MODULES/User
set -Ux SYSTEM_MODULES $MODULES/System

# Git.
source $CONFIG/Fish/git.fish
