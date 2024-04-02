# Error function.
# Its purpose? To look nice.

# Always returns 1.
function throw \
    -d "Print a coloured error message to stdout."

    echo -e -- "$(set_color $fish_color_error -o)error$(set_color normal): $argv"
end
