# Helper functions.
set description __fish_generate_help
function __fish_generate_help \
    -d $description \
    -a command_name \
    -a description \
    -a flags


end

begin
    set description 'Register a directory as an environment variable. Prepends \$CONFIG.'
    function __fish_register_config \
        -d $description \
        -a config_id

        argparse -n fish_register_config -X 1 "h/help=?" -- $argv
        or return


        if test -n $_flag_h
            echo """
      Fish Register Config
      --------------------
      
      $description
      
      Usage
      
       __fish_register_config 
    """
            return
        end

        # set -gx CONFIG_$config_id $(pwd)
    end
end
