# Associative array implementation for Fish Shell.
# Uses a list that iterates by two to create a key-value
# pair through [i, i+1].

source ./error.fish

set flag_pattern '^\\-'
function __assoc_validate_argv \
    -d "Validate a list of arguments to check for invalid options."

    set position 1
    for k in $argv
        if test -z "$last"
            set -- last "$k"
            continue
        end

        if string match -qr $flag_pattern -- $last; and string match -qr $flag_pattern -- $k
            set is_current_idx_key (string match -gr (string join "" -- "$flag_pattern" "(k)") -- "$last")
            if ! test -z $is_current_idx_key
                set -f type key
                # echo "current idx is key: $is_current_idx_key"
            else
                set -f type value
                # echo "current idx is not key: $is_current_idx_key"
            end

            throw "$type at index $position has no value, followed by '$k'"
            return 1
        end
        set -- last "$k"
        set position (math $position + 1)
    end

    return 0
end


function __assoc_fill_list \
    -d "Fill a list with dummy values." \
    -a target_size \
    -a fill_with

    if set -q target_size
        if test $target_size -le 0
            throw "expected target size to be greater than 0 (got $target_size)"
            return 1
        end
    else
        throw "expected target_size to be defined."
        return 1
    end

    if ! set -q fill_with
        set fill_with 0
        set argv argv[1] $fill_with $argv[2..-1]
    end
    set -f list $argv[3..-1]
    set list_size (count $list)

    if test $target_size -lt $list_size
        throw "expected target size ($target_size) to be greater than the list size ($list_size)."
        return 1
    end

    # can be destructive but then the solution for that is
    # don't(tm)
    for num in (seq ( math $target_size-$list_size))
        set -f list $list $fill_with
    end

    echo -E (string join "\n" $list)
    return 0
end

function assoc \
    -d "Create an associative array."
    set argv_old $argv
    argparse -sin assoc h/help p/pretty "D/default=?" -- $argv

    set validate_string '!test -n "$_flag_value"'

    switch $argv[1]
        case parse
            set trimmed_args $argv[2..-1]
            if test (count $trimmed_args) -eq 1
                # it's all one string, split each line 
                # and re-call this function
                set split_args (string split $trimmed_args "\n")
                if test (count $split_args) -eq 1
                    throw "split argv returned single parameter, exiting..."
                    return 1
                end

                __assoc_parse $split_args
                return $status
            end

            for line in $trimmed_args
                if string match -qr "\\{|\\}" $line
                    continue
                end

                set match_result (string match -r "\\[(?<key>.+?)\\]=(?<value>.+)\$" $line)
                if set -q key; and set -q value
                    echo $key $value
                end
            end

            return 0
    end

    if test -n "$_flag_h"
        return 0
    end

    if ! set -q _flag_D
        set -f _flag_D 0
    end

    if ! __assoc_validate_argv $argv
        return 1
    end

    argparse -in assoc "k/key=+$str_test" "v/value=+$str_test" -- $argv
    or return

    if test (count $_flag_k) -gt (count $_flag_v)
        set -f _flag_v (__assoc_fill_list (count $_flag_k) $_flag_D $_flag_v)
    else if test (count $_flag_v) -gt (count $_flag_k)
        throw "expected the amount of keys ($(count $_flag_k)) to be greater than or equal to the amount of values ($(count $_flag_v))."
        return 1
    end

    echo \{
    for num in (seq (count $_flag_k))
        if set -q _flag_p
            echo -en "\t"
        end
        set val \[$_flag_k[$num]\]=$_flag_v[$num]
        if set -q _flag_p
            echo -e "$val,"
        else
            echo -e $val
        end
    end
    echo \}
end
