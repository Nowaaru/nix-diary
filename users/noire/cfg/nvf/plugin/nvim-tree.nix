{
  enable = true;
  mappings = {
    focus = "<leader>e";
    findFile = "<leader>f";
    refresh = "<leader>R";
  };

  setupOpts = {
    reload_on_bufenter = true;
    select_prompts = true;
    respect_buf_cwd = false;

    disable_netrw = true;
    hijack_netrw = true;
    hijack_unnamed_buffer_when_opening = true;
    hijack_cursor = true;

    hijack_directories = {
      enable = true;
      auto_open = true;
    };

    actions = {
      change_dir.restrict_above_cwd = false;
      open_file = {
        quit_on_open = false;
        resize_window = true;
        eject = true;
      };
    };

    filters = {
      dotfiles = true;

      git_clean = false;
      git_ignored = true;
    };

    git = {
      enable = true;
      show_on_dirs = true;
    };

    modified = {
      enable = true;
      show_on_dirs = true;
    };

    renderer = {
      full_name = true;
      highlight_git = true;
      add_trailing = true;
      group_empty = false;

      highlight_opened_files = "icon";
      highlight_modified = "name";

      icons.webdev_colors = true;
      icons.modified_placement = "signcolumn";
    };

    tab = {
      sync = {
        open = true;
        close = true;
        ignore = [];
      };
    };

    ui = {
      confirm.remove = true;
      confirm.trash = true;
    };

    update_focused_file = {
      enable = true;
      update_root = true;
    };

    view = {
      cursorline = true;
      centralize_selection = false;
      preserve_window_proportions = true;

      side = "left";
      signcolumn = "yes";

      number = false;
      relativenumber = false;

      width = {
        min = 30;
        max = 36;
        padding = 1;
      };
    };

    diagnostics.enable = true;
  };
}
