{
    enable = true;

    setupOpts = {
        enable_cursor_hijack = true;
        enable_diagnostics = true;
        enable_git_status = true;
        enable_modified_markers = true;
        enable_opened_markers = true;
        enable_refresh_on_write = true;

        add_blank_line_at_top = false;
        use_libuv_file_watcher = true;
        auto_clean_after_session_restore = true;
        git_status_async = true;

        default_source = "filesystem";

        filesystem = {
            hijack_netrw_behavior = "open_current";
        };

        open_files_do_not_replace_types = [ "terminal" "Trouble" "trouble" "qf" "edgy" ];
    };
}
