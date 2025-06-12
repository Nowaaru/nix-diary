{
  inputs,
  pkgs,
  lib,
  configure,
}: let
  maps = import ./modules {inherit lib;};
  languages = import ./languages.nix inputs pkgs;
  mkUnused = keybinding: "${
    if lib.strings.hasPrefix "<leader>" keybinding
    then ""
    else "<leader>"
  }<leader>${keybinding}";
  util = import ./util.nix lib;
in {
  inherit maps languages;
  # TODO: use withsystem or getsystem so i can use inputs'.["foobar"].packages.default;
  package = inputs.neovim-nightly-overlay.packages.x86_64-linux.default;
  globals = {
    editorconfig = true;
    mapleader = " ";
    maplocalleader = ",";
  };

  options = {
    smartindent = true;
    autoindent = true;

    termguicolors = true;
    signcolumn = "yes";

    splitbelow = true;
    splitright = true;
    wrap = true;

    tabstop = 4;
    shiftwidth = 4;

    mouse = "nvi";

    directory = "/home/noire/.local/state/nvim/swap,~/tmp,/var/tmp,/tmp";
    backupdir = "/home/noire/.local/state/nvim/backup";

    undodir = "/home/noire/.local/state/nvim/undo";
    undofile = true;
  };

  luaConfigPre = '''';

  enableLuaLoader = true;
  withNodeJs = true;
  withPython3 = true;

  viAlias = true;
  vimAlias = true;

  startPlugins = with pkgs.vimPlugins; [oxocarbon-nvim];
  pluginOverrides = {
    # none-ls-nvim = pkgs.fetchFromGitHub {
    #     owner = "nvimtools";
    #     repo = "none-ls.nvim";
    #     rev = "a117163db44c256d53c3be8717f3e1a2a28e6299";
    #     hash = "sha256-KP/mS6HfVbPA5javQdj/x8qnYYk0G6oT0RZaPTAPseM=";
    # };
  };
  pluginRC = {
    alpha = lib.mkForce (lib.hm.dag.entryAfter ["image-nvim"] (util.fetchLuaSource "alpha-startup"));
  };

  luaConfigRC = {
    theme = lib.mkForce (lib.hm.dag.entryBefore ["pluginConfigs" "lazyConfigs"] ''
      require('oxocarbon')
      vim.opt.background = "dark" -- set this to dark or light
      vim.cmd.colorscheme "oxocarbon"

      -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      -- vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
      -- vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
      -- vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
    '');

    lualine-gaps = lib.mkForce (lib.hm.dag.entryAfter ["lualine"] (util.fetchLuaSource "lualine-gaps"));

    dirs = lib.mkForce (lib.hm.dag.entryAnywhere (util.fetchLuaSource "set-dirs"));
  };

  lineNumberMode = "relNumber";
  syntaxHighlighting = true;
  useSystemClipboard = true;
  preventJunkFiles = false;
  searchCase = "smart";
  bell = "on";

  luaConfigPost = '''';

  extraPlugins = with pkgs.vimPlugins; {
    smart-splits = {
      package = smart-splits-nvim;
      setup = ''
        require('smart-splits').setup({});
      '';
    };

    scope-nvim = {
      package = scope-nvim;
      setup = ''
        require("scope").setup({})
      '';
    };

    # TODO: make flash-nvim part of nvf config via modules/neovim-flake
    # flash-nvim = {
    #     package = flash-nvim;
    #     setup = ''
    #             require('flash').setup({});
    #     '';
    # };

    # TODO: make legendary part of nvf config via modules/neovim-flake
    legendary = {
      package = legendary-nvim;
      setup = ''
        require('legendary').setup({})
      '';
    };

    showkeys = {
      package =
        pkgs.fetchFromGitHub
        {
          owner = "NvChad";
          repo = "showkeys";
          hash = "sha256-uZnJaN/JDCfWfzGmjwJ0CmpYP9GDn4MbyoZU06QIArI=";
          rev = "10cfd50";
        };

      setup = ''
        require("showkeys").setup({
          timeout = 3, -- in seconds
          maxkeys = 5,

          excluded_modes = {"i"};
          position = "top-center",

          keyformat = {
            ["<BS>"] = "󰁮 ",
            ["<CR>"] = "󰘌",
            ["<Space>"] = "󱁐",
            ["<Up>"] = "󰁝",
            ["<Down>"] = "󰁅",
            ["<Left>"] = "󰁍",
            ["<Right>"] = "󰁔",
            ["<PageUp>"] = "Page 󰁝",
            ["<PageDown>"] = "Page 󰁅",
            ["<M>"] = "Alt",
            ["<C>"] = "Ctrl",
          },
        });
      '';
    };
  };

  debugMode = {
    enable = false;
    level = 16;

    logFile = "/tmp/nvf.log";
  };

  formatter.conform-nvim = {
    enable = true;
    setupOpts = {
      formatters_by_ft = {
        nix = ["nixd"];
        javascript = ["dprint"];
        typescript = ["dprint"];
        rust = ["rustfmt" "rust-analyzer"];
      };

      notify_on_error = true;
      notify_no_formatters = true;
      formatters.command = "${pkgs.dprint}";
    };
  };

  binds = {
    whichKey = {
      enable = true;
      setupOpts = {
        notify = true;
        preset = "helix";
        replace = {
          "<cr>" = "RETURN";
          "<leader>" = "SPACE";
          "<space>" = "SPACE";
          "<tab>" = "TAB";
        };
      };

      # TODO: Make registers.
      register = {
        "<leader>f" = "[] Telescope";
        "<leader>q" = "[] Super";
        "<leader>o" = "[] Notes";
        "<leader>d" = "[] Debug";
        "<leader>m" = "[] Minimap";
        "<leader>g" = "[] GitSigns";
        "<leader>b" = "[] Buffers";
        "<leader>t" = "[] Tabs";
        "<leader>T" = "[] Todo";
        "<leader>c" = "[] Code Actions";

        "<leader>l" = "[] LSP Actions";
        "<leader>lg" = "[] LSP - Go To...";
        "<leader>lt" = "[] LSP - Toggle...";
        "<leader>lw" = "[] LSP - Workspace";

        "<leader>x" = "[] Trouble";
        "<leader><leader>" = "[] Lost & Found";
      };
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

  autocomplete = {
    nvim-cmp = {
      enable = true;
      setupOpts = {
        completion.completeopt = "menu,menuone,preview";

        sourcePlugins = with pkgs.vimPlugins; [
          "cmp-nvim-lsp-signature-help"
        ];

        sorting.comparators = [
          "exact"
          "offset"
          "locality"
          "scopes"
          "kind"
          "recently_used"
          "length"
          "sort_text"
        ];

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
    nvimTree = configure "nvf.plugin.nvim-tree";
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
        previewHunk = "<leader>gp";
      };

      codeActions.enable = true;
    };

    vim-fugitive.enable = false;
  };

  lsp = {
    enable = true;
    formatOnSave = false;

    mappings = {
      hover = "<S-k>";
      goToType = "<leader>cgt";
      goToDefinition = "<leader>cgd";
      goToDeclaration = "<leader>cgD";

      addWorkspaceFolder = "<leader>cwa";
      documentHighlight = "<leader>cH";
      codeAction = "<leader>ca";
      format = "<leader>cf";
    };

    lspconfig = {
      enable = true;
      sources = {};
    };

    lspsaga = {
      # lspsaga is fried :/
      enable = true;
    };

    null-ls = {
      enable = true;
    };

    trouble = {
      enable = true;
      mappings = {
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
    addDefaultGrammars = false;

    highlight.enable = true;
    context.enable = true;
    indent.enable = true;

    grammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      fish
      bash
      luau
      lua
      luadoc
      nix
      rust
      typescript
      javascript
      json
    ];
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
        quickFix = "<leader>Tq";
        trouble = "<leader>Tx";
        telescope = mkUnused "Ts";
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
      logo_tooltip = "The Unstoppable 10x Programmer vs the Immovable NeoVim Config";

      line_number_text = "[%s/%s]";

      main_image = "language";
      git_commit_text = "🌿 Using LazyGit";
      plugin_manager_text = "Where... am I?";
      reading_text = "📃 Catching up on %s...";
      terminal_text = "🖥️ Terminal time!";
      file_explorer_text = "🗂️ Using %s";
      editing_text = "💥🔨 Editing %s";
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
    enable = false;

    name = "tokyonight";
    style = "moon";
    # transparent = true;
    # style = "dark";
  };

  ui = {
    noice.enable = true;
    illuminate.enable = true;

    breadcrumbs = {
      enable = true;
      lualine.winbar.alwaysRender = true;
    };

    fastaction = {
      enable = true;
    };

    borders = {
      enable = true;
      globalStyle = "single";

      plugins = {
        nvim-cmp = {
          enable = true;
          style = "single";
        };

        which-key = {
          enable = true;
          style = "double";
        };

        lsp-signature = {
          enable = true;
          style = "single"; # maybe single?
        };

        fastaction = {
          enable = true;
          style = "rounded";
        };
      };
    };
  };

  utility = {
    preview.markdownPreview.enable = true;
    diffview-nvim.enable = true;
    vim-wakatime.enable = true;
    icon-picker.enable = true;

    yanky-nvim = {
      enable = true;
      setupOpts.ring.storage = "shada";
    };

    ccc = {
      enable = true;
    };

    motion.hop = {
      enable = true;
    };

    motion.precognition = {
      enable = true;
      setupOpts.showBlankVirtLine = false;
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
      setupOpts = {
        keymaps = {
          change = "cs";
          change_line = "cS";
          delete = "ds";

          normal = "ys";
          normal_line = "yss";
          normal_cur = "yS";
          normal_cur_line = "ySS";

          insert = "<C-y>s";
          insert_line = "<C-y>S";

          visual = "gs";
          visual_line = "gS";
        };
      };
    };
  };

  visuals = {
    cellular-automaton = {
      enable = true;
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

    cinnamon-nvim = {
      enable = false;
      setupOpts = {
        max_delta.line = true;
        keymaps = {
          extra = true;
          basic = true;
        };
      };
    };

    indent-blankline = {
      enable = true;
      setupOpts.scope = {
        show_start = true;
        show_end = true;
        show_exact_scope = true;
      };
    };

    rainbow-delimiters.enable = true;
    nvim-cursorline.enable = true;
    nvim-web-devicons.enable = true;
    tiny-devicons-auto-colors.enable = true;
  };

  tabline.nvimBufferline = {
    enable = true;
    mappings = {
      closeCurrent = null;

      cyclePrevious = null;
      cycleNext = null;

      movePrevious = null;
      moveNext = null;

      pick = null;
      sortByDirectory = null;
      sortByExtension = null;
      sortById = null;
    };
  };

  snippets = {
    luasnip.enable = true;
  };

  telescope = {
    enable = lib.mkForce true;
  };

  spellcheck.enable = lib.mkForce false;
}
