# Initialize auxiliary paths.
set -Ux CONFIG $DIARY/Config
set -Ux MODULES $DIARY/Modules

set -Ux USER_MODULES $MODULES/User
set -Ux SYSTEM_MODULES $MODULES/System

# Initialize abbreviations.
abbr -a --position command mod "cd $MODULES"
abbr -a --position command conf "cd $CONFIG"

# Aliases.
source $CONFIG/Fish/alias.fish

# Git.
source $CONFIG/Fish/alias.fish
