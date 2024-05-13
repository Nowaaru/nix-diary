{
  inputs,
  pkgs,
  lib,
}: let
  maps = import ./keybindings.nix;
  languages = import ./languages.nix pkgs;
  mkUnused = keybinding: "<leader><leader>${keybinding}";
in {
  inherit maps languages;

  luaConfigPre = '''';
  enableEditorconfig = true;
  enableLuaLoader = true;
  withNodeJs = true;
  withPython3 = true;

  viAlias = true;
  # luaConfigRC = lib.hm.dag.entryAnywhere "";
  vimAlias = true;

  syntaxHighlighting = true;
  useSystemClipboard = true;
  preventJunkFiles = false;
  mapLeaderSpace = true;
  showSignColumn = true;
  searchCase = "smart";
  autoIndent = true;
  bell = "on";
  mouseSupport = "a";
  disableArrows = true;
  lineNumberMode = "relNumber";
  luaConfigPost = '''';

  extraPlugins = with pkgs.vimPlugins; {
    smart-splits = {
      package = smart-splits-nvim;
      setup = ''
        require('smart-splits').setup({});
      '';
    };

    legendary = {
      package = legendary-nvim;
      setup = ''
        require('legendary').setup({})
      '';
    };
  };

  debugMode = {
    enable = false;
    level = 16;

    logFile = "/tmp/nvf.log";
  };

  autocomplete = {
    enable = true;
    alwaysComplete = true;
    type = "nvim-cmp";

    mappings = {
      confirm = "<CR>";
      complete = "<C-Space>";

      previous = "<S-Tab>";
      next = "<Tab>";

      close = "<C-Esc>";

      scrollDocsUp = "<C-S-,>";
      scrollDocsDown = "<C-S-/>";
    };
  };

  autopairs = {
    enable = true;
    type = "nvim-autopairs";
  };

  binds = {
    whichKey = {
      enable = true;

      # TODO: Make registers.
      register = {};
    };

    # TODO: PR nvf to include Legendary.
    # cheatsheet.enable = true;
  };

  comments = {
    comment-nvim = {
      enable = true;
      mappings = {
        toggleCurrentBlock = "gbc";
        toggleCurrentLine = "gcc";

        toggleOpLeaderBlock = "gb";
        toggleOpLeaderLine = "gc";

        toggleSelectedBlock = "gb";
        toggleSelectedLine = "gc";
      };
    };
  };

  dashboard = {
    alpha.enable = true;
    dashboard-nvim.enable = false;
  };

  debugger = {
    nvim-dap.ui.enable = true;
  };

  filetree = {
    nvimTree = {
      enable = true;
      mappings = {
        focus = "<leader>e";
        refresh = "<leader>tr";
        findFile = "<leader>tf";
      };

      setupOpts = {
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
          change_dir.restrict_above_cwd = true;
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
          reload_on_bufenter = true;
          add_trailing = true;
          group_empty = false;

          highlight_opened_files = "icon";
          highlight_modified = "name";
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
        icons.webdev_colors = true;
        icons.modified_placement = "signcolumn";
      };
    };
  };

  git = {
    gitsigns = {
      enable = true;
      mappings = {
        blameLine = "<leader>gb";

        diffThis = "<leader>gd";
        diffProject = "<leader>gD";

        nextHunk = "]c";
        previousHunk = "[c";

        resetBuffer = "<leader>gsRB";
        resetHunk = "<leader>gsRR";

        stageHunk = "<leader>gss";
        stageBuffer = "<leader>gsS";
        toggleBlame = "<leader>gstb";
        toggleDeleted = "<leader>gstd";
        undoStageHunk = "<leader>gshu";
      };

      codeActions.enable = true;
    };

    vim-fugitive.enable = false;
  };

  lsp = {
    enable = true;
    formatOnSave = true;

    mappings = {
      hover = "<S-k>";
      goToType = "<leader>lgt";
      goToDefinition = "<leader>lgd";
      goToDeclaration = "<leader>lgD";

      addWorkspaceFolder = "<leader>lwa";
      documentHighlight = "<leader>lH";
      codeAction = "<leader>la";
      format = "<leader>cf";
    };

    lspkind = {
      enable = true;
      mode = "symbol_text";
    };

    lspconfig = {
      enable = true;
      sources = {};
    };

    lspsaga = {
      enable = true;
      mappings = {
        rename = "<leader>cr";
        showLineDiagnostics = "<leader>cD";
        showCursorDiagnostics = "<leader>cd";
        codeAction = mkUnused "ca";

        previousDiagnostic = "<leader>lp";
        nextDiagnostic = "<leader>ln";
        lspFinder = "<leader>lf";

        renderHoveredDoc = "<leader>lh";
        smartScrollUp = "<C-f>";
        smartScrollDown = "<C-b>";
        signatureHelp = "<leader>ls";
      };
    };

    null-ls = {
      enable = true;
      sources = {
        # nixd = ''
        #     local null_ls = require("null-ls");
        #     local helpers = require("null-ls.helpers");
        #
        #
        #     local source = null_ls.register({
        #         name = "nixd",
        #         filetypes = { "nix" },
        #         method = null_ls.methods.DIAGNOSTICS,
        #
        #         generator = helpers.generator_factory({
        #             command = "nixd";
        #             on_output = function(params)
        #                 print("output:", vim.inspect(params.output));
        #             end
        #         });
        #     });
        # '';
      };
    };

    nvimCodeActionMenu = {
      enable = true;
      show = {
        actionKind = true;
        details = true;
        diff = true;
      };

      mappings.open = "<leader>ca";
    };

    trouble = {
      enable = true;
      mappings = {
        toggle = "<leader>xx";
        quickfix = "<leader>xq";

        workspaceDiagnostics = "<leader>xD";
        documentDiagnostics = "<leader>xd";

        lspReferences = mkUnused "lr";
        locList = mkUnused "xl";
      };
    };

    lspSignature.enable = true;
    lightbulb.enable = true;
  };

  treesitter = {
    enable = true;
    autotagHtml = true;
    addDefaultGrammars = true;

    highlight.enable = true;
    context.enable = true;
    indent.enable = true;
  };

  minimap = {
    codewindow = {
      enable = true;
      mappings = {
        open = "<leader>mo";
        close = "<leader>mc";
        toggle = "<leader>mm";
        toggleFocus = "<leader>mf";
      };
    };

    minimap-vim.enable = false;
  };

  notes = {
    todo-comments = {
      enable = true;
      mappings = {
        quickFix = "<leader>tdq";
        trouble = "<leader>tdt";
        telescope = mkUnused "Utds";
      };
    };

    mind-nvim.enable = true;
  };

  presence.neocord = {
    enable = true;

    setupOpts = {
      log_info = "info";
      show_time = true;
      enable_line_number = true;
      blacklist = inputs.secrets.neocord-blacklist;

      logo = "auto";
      logo_tooltip = "Once you're too far in, you can never go back...";

      line_number_text = "[%s/%s]";

      main_image = "language";
      git_commit_text = "🌿 Using LazyGit";
      plugin_manager_text = "Where... am I?";
      reading_text = "📃 Catching up on %s...";
      terminal_text = "🖥️ Terminal time!";
      file_explorer_text = "🗂️ Using %s";
      editing_text = "💥🔨 Tinkering with %s";
      workspace_text = "🧰 %s";
    };
  };

  projects.project-nvim = {
    enable = true;
  };

  statusline.lualine = {
    enable = true;
    theme = "auto";
    icons.enable = true;

    refresh = {
      winbar = 1000;
      tabline = 1000;
      statusline = 1000;
    };

    activeSection = {
      a = [];
      b = [];
      c = [];
      #--------#
      x = [];
      y = [];
      z = [];
    };

    extraActiveSection = {
      a = [];
      b = [];
      c = [];
      #--------#
      x = [];
      y = [];
      z = [];
    };

    inactiveSection = {
      a = [];
      b = [];
      c = [];
      #--------#
      x = [];
      y = [];
      z = [];
    };

    extraInactiveSection = {
      a = [];
      b = [];
      c = [];
      #--------#
      x = [];
      y = [];
      z = [];
    };

    sectionSeparator.left = "";
    sectionSeparator.right = "";

    componentSeparator.left = "";
    componentSeparator.right = "";
  };

  terminal = {
    toggleterm = {
      enable = true;
      lazygit = {
        enable = true;
        direction = "float";
      };
    };
  };

  theme = {
    enable = true;

    name = "onedark";
    style = "dark";
  };

  ui = {
    noice.enable = true;
    illuminate.enable = true;

    breadcrumbs = {
      enable = true;
      alwaysRender = true;
    };

    borders = {
      enable = true;
      globalStyle = "single";

      plugins = {
        nvim-cmp = {
          enable = true;
          style = "single";
        };

        code-action-menu = {
          enable = true;
          style = "double";
        };

        which-key = {
          enable = true;
          style = "double";
        };

        lsp-signature = {
          enable = true;
          style = "shadow"; # maybe single?
        };

        lspsaga = {
          enable = true;
          style = "single";
        };
      };
    };
  };

  utility = {
    preview.markdownPreview.enable = true;
    diffview-nvim.enable = true;
    vim-wakatime.enable = true;
    icon-picker.enable = true;

    ccc = {
      enable = true;
    };

    images.image-nvim = {
      enable = true;

      setupOpts = {
        backend = "kitty";
        downloadRemoteImages = true;
        integrations.markdown.downloadRemoteImages = true;
      };
    };

    surround = {
      enable = true;
      useVendoredKeybindings = true;
    };
  };

  visuals = {
    enable = true;

    cellularAutomaton = {
      mappings.makeItRain = "<leader>fml";
    };

    fidget-nvim = {
      enable = false;
      setupOpts = {
        integration = {
          nvim-tree.enable = true;
        };

        notification = {
          window = {
            align = "bottom";
            border = "single";
            x_padding = 2;
            y_padding = 2;
          };
        };

        progress = {
          icon.pattern = "dots";
          display.skip_history = true;

          lsp = {
            progress_ringbuf_size = 100;
            log_handler = true;
          };

          poll_rate = 0;
          suppress_on_insert = false;
          ignore_empty_message = true;
          ignore_done_already = false;
        };
      };
    };
    cursorline.enable = true;
    smoothScroll.enable = true;
    nvimWebDevicons.enable = true;
  };

  tabline.nvimBufferline.enable = true;
  snippets.vsnip.enable = true;
  spellcheck.enable = lib.mkForce false;
}
