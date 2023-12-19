# Initialize auxiliary paths.
set -Ux CONFIG $DIARY/Config
set -Ux MODULES $DIARY/Modules

# Wine.
source $CONFIG/Fish/wine.fish

# Initialize abbreviations.
abbr -a --position command mod "cd $MODULES"
abbr -a --position command conf "cd $CONFIG"
