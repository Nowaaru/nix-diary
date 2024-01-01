function pre_git -e fish_preexec
    set GIT_CONFIG_DIR $USER_MODULES/Programming/Git
    set PRIVATE_NIX_PATH $GIT_CONFIG_DIR/private.nix
    set REPO_DIR (git rev-parse --show-toplevel)

    if string match -qr (string escape (path resolve $DIARY)) (string escape (path resolve $REPO_DIR))
        if test (path basename $REPO_DIR) = (path basename $DIARY)
            if test -f $PRIVATE_NIX_PATH -a -e $PRIVATE_NIX_PATH
                if git ls-files --error-unmatch $PRIVATE_NIX_PATH
                    git add -Nf $PRIVATE_NIX_PATH
                end
            end
        end
    end
end
