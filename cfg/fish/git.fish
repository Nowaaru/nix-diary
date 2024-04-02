function pre_git -e fish_preexec
    set GIT_CONFIG_DIR $USER_MODULES/dev/git
    set PRIVATE_NIX_PATH $GIT_CONFIG_DIR/private.nix

    git rev-parse --is-inside-work-tree >/dev/null 2>&1
    if test $status -eq 0
        set REPO_DIR (git rev-parse --show-toplevel)
        if string match -qr (string escape (path resolve $DIARY)) (string escape (path resolve $REPO_DIR))
            if test (path basename $REPO_DIR) = (path basename $DIARY)
                if test -f $PRIVATE_NIX_PATH -a -e $PRIVATE_NIX_PATH
                    git add -Nf $PRIVATE_NIX_PATH
                end
            end
        end
    end
end
