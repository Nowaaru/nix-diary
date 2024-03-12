{
  profile ? "default",
  inputs,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkForce mkOverride;
  inherit (inputs.neovim-flake.lib.nvim) dag;

  resizeHeight = 2;
  no = ''<cmd>echo "You can't do that."<cr>'';

  # read all folders in the ./Modules
  # path, put the filename (extension excluded)
  # inside of the folder and merge to vim attrset
  st = w: builtins.trace w w;
  util = import ./util.nix {inherit lib;};
  keys = import ./keys.nix {inherit lib;};
  config = import ./config.nix {
    inherit inputs pkgs;
  };
  autocmds = import ./autocmds {
    inherit lib dag;
  };
in {
  vim = rec {
    cursorlineOpt = "number";

    # Aliases. You should probably keep these enabled.
    viAlias = mkForce true;
    vimAlias = mkForce true;

    # RCs.
    luaConfigRC =
      {
        csharpls-extended-lsp = dag.entryAnywhere ''
          local pid = vim.fn.getpid()
          -- On linux/darwin if using a release build, otherwise under scripts/OmniSharp(.Core)(.cmd)
          -- on Windows
          -- local omnisharp_bin = "/path/to/omnisharp/OmniSharp.exe"

          local config = {
            handlers = {
              ["textDocument/definition"] = require('csharpls_extended').handler,
              ["textDocument/typeDefinition"] = require('csharpls_extended').handler,
            },
            cmd = { "${pkgs.csharp-ls}/bin/csharp-ls" },
            -- rest of your settings
          }

          require'lspconfig'.csharp_ls.setup(config)

        '';
      }
      // autocmds;
    configRC = with pkgs.vimPlugins; {
    };

    # plugins.
    extraPlugins = with pkgs.vimPlugins; {
      csharpls-extended = {
        package = csharpls-extended-lsp-nvim;
      };

      smart-splits = {
        package = smart-splits-nvim;
        setup = ''
          require('smart-splits').setup {
            resize_mode = {
              hooks = {
                on_leave = require('bufresize').register;
              };
            };
          };
        '';
      };

      legendary = {
        package = legendary-nvim;
        setup = ''
          require('legendary').setup {};
        '';
      };

      consistent-buffer-size = {
        package = pkgs.fetchFromGitHub {
          owner = "kwkarlwang";
          repo = "bufresize.nvim";
          rev = "3b19527ab936d6910484dcc20fb59bdb12322d8b";
          sha256 = "sha256-6jqlKe8Ekm+3dvlgFCpJnI0BZzWC3KDYoOb88/itH+g=";
        };
        setup = ''
          require('bufresize').setup();
        '';
      };
    };

    # Generic options.
    autoIndent = mkDefault true;
    colourTerm = mkDefault true;
    hideSearchHighlight = mkDefault true;
    useSystemClipboard = mkForce true;
    enableLuaLoader = mkDefault true;
    showSignColumn = mkDefault true;
    searchCase = mkForce "smart";
    bell = mkForce "visual";

    splitBelow = mkDefault true;
    splitRight = mkDefault true;

    disableArrows = mkDefault false; # Turns out this only disables in Insert mode. Why..?

    leaderKey = mkDefault " ";
    lineNumberMode = mkDefault "relNumber";
    mapLeaderSpace = mkDefault true;

    # Domain-based options.
    autocomplete.enable = mkForce true;
    autocomplete.mappings = {
      close = mkDefault "<C-e>"; # Binding escape occasionally requires the user to press <Esc> twice. Oh well. complete = mkDefault "<C-Space>"; # Not actually to confirm, only open the autocomplete window.
      confirm = mkDefault "<Enter>"; # This one confirms.

      # previous = mkDefault "<Tab>";
      # next = mkDefault "<S-Tab>";

      scrollDocsUp = mkDefault "<C-S-K>";
      scrollDocsDown = mkDefault "<C-S-J>";
    };

    autopairs.enable = mkForce true;
    autopairs.type = mkForce "nvim-autopairs";

    spellChecking.enable = mkForce false; # This shit's broken.
    spellChecking.enableProgrammingWordList = mkDefault true;
    spellChecking.languages = mkDefault ["en"];

    /*
    Enable the most powerful commenting system
    known on planet Earth. Ohhh yeah.
    */
    comments.comment-nvim = {
      enable = mkDefault true;
      mappings = {
        # Normal keybinds.
        toggleCurrentBlock = mkDefault "gcb";
        toggleCurrentLine = mkDefault "gcc";

        # Operator pending keybinds.
        toggleOpLeaderBlock = mkDefault "gb";
        toggleOpLeaderLine = mkDefault "gc";

        toggleSelectedBlock = mkDefault "gb";
        toggleSelectedLine = mkDefault "gc";
      };
    };

    /*
    Should be configured
    through the luaConfigRC
    */
    dashboard.alpha = {
      enable = mkDefault true;
    };

    /*
    Borders.
    'Nuff said.
    */
    ui.borders = {
      enable = mkDefault true;
      globalStyle = mkDefault "single"; # rounded..?

      plugins = {
        code-action-menu.enable = mkDefault true;
        code-action-menu.style = mkDefault "double";

        lsp-signature.enable = mkDefault true;
        lsp-signature.style = mkDefault "none";

        lspsaga.enable = mkDefault true;
        lspsaga.style = mkDefault "shadow";

        nvim-cmp.enable = mkDefault true;
        nvim-cmp.style = mkDefault "none";

        which-key.enable = mkDefault true;
        which-key.style = mkDefault "rounded";
      };
    };

    /*
    Breadcrumbs in your lualine, breadcrumbs in
    your lualine!

    Breadcrumbs are highly useful.
    */
    ui.breadcrumbs = {
      enable = mkDefault true;
      alwaysRender = mkDefault true;

      navbuddy.enable = mkDefault true;
      navbuddy.nodeMarkers.enable = mkDefault true;
    };

    /*
    Highlight words depending
    on whether they tell some form of
    recognized color data.
    */

    ui.colorizer = {
      enable = mkDefault true;
      options = {
        rgb = mkDefault true;
        rrggbb = mkDefault true;
        rgb_fn = mkDefault true;

        css = mkDefault true;
        css_fn = mkDefault true;
        hsl_fn = mkDefault true;

        mode = mkDefault "foreground";
      };
    };

    /*
    Show other instances of the current word
    underneath the cursor.
    */
    ui.illuminate = {
      enable = mkDefault true;
    };

    /*
    Change the background colour of the
    current line behind the cursor when
    the user's current mode changes.

    It's neat.. no - it's modes!
    */
    ui.modes-nvim = {
      enable = mkDefault false;
      setCursorline = mkDefault false;

      colors.copy = mkDefault "#f5c359";
      colors.delete = mkDefault "#78ccc5";
      colors.visual = mkDefault "#9745be";
    };

    /*
    That one custom window
    overhaul that you see on almost
    every Neovim configuration.

    It's on this one too, bro. :P
    */
    ui.noice = {
      enable = mkDefault true;
    };

    /*
    Coloured column line indicator that appears
    when you're approaching or passing the maximum
    permitted characters for a language.

    Good for enforcing formatting standards.
    */
    ui.smartcolumn = {
      enable = mkDefault false;
      showColumnAt = mkDefault 120;
      columnAt.languages = mkDefault {};
    };

    /*
    Allow VSCode-like snippets
    while editing.
    */
    snippets.vsnip = {
      enable = mkForce true;
    };

    /*
    Icons.
    */
    visuals.nvimWebDevicons = {
      enable = mkForce true;
    };

    /*
    Cute visuals to spice up
    your quirky Vim programming life.
    */
    visuals.enable = mkForce true;

    /*
    Cellular Automaton:
    Turn your code into sand!
    */
    visuals.cellularAutomaton = {
      enable = mkForce true;
      mappings.makeItRain = mkDefault "<leader>fml"; # bound to "fml" for good reason. ;-;
    };

    /*
    Highlight the current line
    your cursor is on.
    */
    visuals.cursorline = {
      enable = mkDefault true;
      lineNumbersOnly = mkDefault true;
      lineTimeout = mkDefault 0; # In milliseconds.
    };

    /*
    "What's taking my Vim so long! I want to type!"
    Is that you? Well then, maybe take a gander at fidget-nvim.

    Shows the current status of the LSP in the bottom-right
    corner of the screen.
    */
    visuals.fidget-nvim = {
      enable = mkDefault true;
      setupOpts.notification.window.align = mkDefault "bottom";
    };

    /*
    Alerts the user on what was changed and what wasn't
    after an undo. Never forget.
    */
    visuals.highlight-undo = {
      enable = mkDefault true;
      duration = mkDefault 500; # In milliseconds.

      highlightForCount = mkDefault true;
    };

    /*
    Add virtual text to illustrate the recommended,
    current, or proper indentation.

    Also virtually shows visual newline characters.
    */
    visuals.indentBlankline = {
      enable = mkDefault true;
      fillChar = mkDefault " ";
      scope.enabled = mkDefault true;
    };

    /*
    Enable the scrollbar. I don't know why you'd need
    this in *vim* of all editors.

    But regardless, you do you. You're powerful as you are.
    Good luck.
    */
    visuals.scrollBar = {
      enable = mkDefault true;
    };

    /*
    Smooth scroll-ly!

    ..wait.
    */
    visuals.smoothScroll = {
      enable = mkDefault true;
    };

    /*
    Discord rich presence.
    Likely will only work with
    Venncord.
    */
    presence.neocord = {
      enable = mkDefault true;
      enable_line_number = mkDefault true;

      auto_update = mkDefault true;
      show_time = mkDefault true;

      logo = mkDefault "auto";
      logo_tooltip = mkDefault "The One True Text Editor";

      rich_presence = {
        editing_text = mkDefault "Editing: %s";
        reading_text = mkDefault "Editing: %s [🔒]";
        file_explorer_text = mkDefault "Browsing: %s";
        workspace_text = mkDefault "Repository: %s";
        terminal_text = mkDefault "Terminal";
        line_number_text = mkDefault "[%s/%s]";
      };
    };

    /*
    Essentially, a more specific version of
    telescope.nvim. Search various caches
    of projects instead of arbitrary folders.
    */
    projects.project-nvim = {
      enable = mkDefault true;
    };

    git = {
      enable = mkDefault true;
      gitsigns = {
        enable = mkDefault true;
        codeActions = mkDefault true;

        mappings = {
          blameLine = mkDefault "<leader>gb";
          diffProject = mkDefault "<leader>gD";
          diffThis = mkDefault "<leader>gd";

          previousHunk = mkDefault "[c";
          previewHunk = mkDefault "<leader>gp";
          nextHunk = mkDefault "]c";

          resetHunk = mkDefault "<leader>gr";
          resetBuffer = mkDefault "<leader>gR";

          stageHunk = mkDefault "<leader>gs";
          stageBuffer = mkDefault "<leader>gS";

          undoStageHunk = mkDefault "<leader>gu";

          toggleBlame = mkDefault "<leader>gtb";
          toggleDeleted = mkDefault "<leader>gtd";
        };
      };
    };
    /*
    Filetree.
    */
    filetree.nvimTree = {
      enable = mkForce true;
      disableNetrw = mkForce true;
      selectPrompts = mkForce true;

      hijackUnnamedBufferWhenOpening = mkDefault true;
      hijackCursor = mkDefault true;
      hijackNetrw = mkDefault true;
      hijackDirectories = {
        enable = mkForce true;
        autoOpen = mkDefault true;
      };

      # Options related to
      # synchronization.
      respectBufCwd = mkDefault true; # Automatically change `cwd` based on buffer location
      updateFocusedFile = {
        enable = mkDefault true; # Auto-expand folders to the target buffer location.
        updateRoot = mkDefault true;
      };

      git = {
        disableForDirs = mkDefault [];
        showOnDirs = mkDefault true;
        showOnOpenDirs = mkDefault true;
      };

      ui = {
        confirm.remove = mkDefault true;
        confirm.trash = mkDefault true;
      };

      sort.foldersFirst = mkDefault true;

      tab.sync = {
        open = mkDefault true;
        close = mkDefault true;
      };

      diagnostics = {
        enable = mkDefault true;
        showOnDirs = mkDefault true;
        showOnOpenDirs = mkDefault true;
      };

      filters = {
        dotfiles = mkDefault true;
        gitIgnored = mkDefault true;

        exclude = mkDefault [];
      };

      mappings = {
        toggle = mkDefault "<leader>e";
        refresh = mkDefault "<leader>Er";
        findFile = mkDefault "<leader>Ef";
      };

      modified = {
        enable = mkDefault true;
        showOnDirs = mkDefault false;
      };

      renderer = {
        addTrailing = mkDefault true;
        groupEmpty = mkDefault false;
        highlightGit = mkDefault true;
        # highlightModified = "icon";
        highlightOpenedFiles = mkDefault "name";

        indentMarkers.enable = mkDefault true;
        icons = {
          gitPlacement = mkDefault "signcolumn";
          modifiedPlacement = mkDefault "signcolumn";

          show = {
            git = mkDefault true;
            modified = mkDefault true;
          };
        };
      };

      filesystemWatchers.enable = mkDefault true;

      actions = {
        useSystemClipboard = mkDefault true;

        openFile = {
          eject = mkForce true;
          # quitOnOpen = mkForce true; /* ends up being more of a hassle than one would think... */
        };

        changeDir = {
          enable = mkForce true;
          global = mkForce false; # Could cause issues with the nvimTree.syncRootWithCwd option.
        };

        removeFile = {
          closeWindow = mkForce true;
        };
      };
    };

    terminal = {
      toggleterm = {
        enable = mkDefault true;
        enable_winbar = mkDefault false; # ...Why would you need this? o_ o

        lazygit = {
          enable = mkDefault true;
          direction = mkDefault "float";
          mappings.open = mkDefault "<leader>gg";
        };
      };
    };

    /*
    Lualine as the statusbar.
    */
    statusline.lualine = {
      enable = mkDefault true;
      icons.enable = mkDefault true;
    };

    /*
    Cool notifications.
    */
    notify.nvim-notify = {
      enable = mkDefault true;
    };

    notes.todo-comments = {
      enable = mkDefault true;
    };

    # Tabline, formally known as the
    # bufferline.
    tabline.nvimBufferline = {
      enable = mkDefault true;

      mappings = {
        cycleNext = mkDefault "<leader>bn";
        cyclePrevious = mkDefault "<leader>bp";

        moveNext = mkDefault "<leader>bN";
        movePrevious = mkDefault "<leader>bP";

        sortByDirectory = mkDefault "<leader>bsd";
        sortByExtension = mkDefault "<leader>bse";
        sortById = mkDefault "<leader>bsi";

        pick = mkDefault "<leader>bc";
      };
    };

    lsp = {
      mappings = {
        format = mkDefault "<leader>cf";
        documentHighlight = mkDefault "<leader>lH";

        goToDeclaration = mkDefault "gD";
        goToDefinition = mkDefault "gd";
        goToType = mkDefault "gt";

        hover = mkDefault "<Nop>";
      };

      null-ls = {
        enable = mkForce true;
        sources = {};
      };

      lspkind = {
        enable = mkDefault true;
        mode = mkDefault "symbol_text";
      };

      lsplines = {
        enable = mkDefault true;
      };

      lspsaga = {
        enable = mkDefault true;
        mappings = {
          previewDefinition = mkDefault "<leader>cp";
          codeAction = mkDefault "<Nop>"; # disabled in favor of nvimCodeActionMenu.
          lspFinder = mkDefault "<leader>lF";

          previousDiagnostic = mkDefault "[";
          nextDiagnostic = mkDefault "]";

          showCursorDiagnostics = mkDefault "<leader>cd";
          showLineDiagnostics = mkDefault "<leader>cD";
          signatureHelp = mkDefault "<leader>cs";
          rename = mkDefault "<leader>cr";

          renderHoveredDoc = mkDefault "K";
        };
      };

      nvim-docs-view = {
        enable = mkDefault true;
        height = mkDefault 10;
        width = mkDefault 60;
        position = mkDefault "right";

        mappings = {
          viewToggle = mkDefault "<leader>lvt";
          viewUpdate = mkDefault "<leader>lvu";
        };
      };

      nvimCodeActionMenu = {
        enable = mkDefault true;

        show.actionKind = mkDefault true;
        show.details = mkDefault true;
        show.diff = mkDefault true;

        mappings.open = mkDefault "<leader>ca";
      };

      trouble = {
        enable = mkForce true;
        mappings = {
          documentDiagnostics = mkDefault "<leader>ld";
          workspaceDiagnostics = mkDefault "<leader>lwd";

          lspReferences = mkDefault "<leader>lr";
          locList = mkDefault "<leader>xl";

          quickfix = mkDefault "<leader>xq";
          toggle = mkDefault "<leader>xx";
        };
      };
    };

    /*
    Search for files across the filesystem
    using telescope.nvim.
    */
    telescope = {
      enable = mkForce true;
      mappings = {
        open = mkDefault "<leader>tt";
        buffers = mkDefault "<leader>tb";
        diagnostics = mkDefault "<leader>td";

        findFiles = mkDefault "<leader>ff";
        findProjects = mkDefault "<leader>fp";

        gitBranches = mkDefault "<leader>tGB";
        gitBufferCommits = mkDefault "<leader>tGc";

        gitCommits = mkDefault "<leader>tGC";
        gitStash = mkDefault "<leader>tGS";

        gitStatus = mkDefault "<leader>tGs";
        helpTags = mkDefault "<leader>tGt";
        liveGrep = mkDefault "<leader>tGg";

        lspTypeDefinitions = mkDefault "<leader>tLd";
        lspDefinitions = mkDefault "<leader>tLD";

        lspReferences = mkDefault "<leader>tLr";
        lspImplementations = mkDefault "<leader>tLi";

        lspDocumentSymbols = mkDefault "<leader>tLs";
        lspWorkspaceSymbols = mkDefault "<leader>tLS";

        treesitter = mkDefault "<leader><leader>t";
      };
    };

    /*
    Current theme settings.
    */
    theme = {
      enable = mkDefault true;
      name = mkDefault "onedark";
      style = mkDefault "dark";
      transparent = mkDefault true;
    };

    /*
    Treesitter. Basically, it's mandatory.
    */
    treesitter = {
      enable = mkForce true;
      autotagHtml = mkDefault true;

      fold = mkDefault true;
      grammars = with pkgs;
        mkDefault [
          # Insert your custom Treesitter
          # grammar packages here.
        ];

      # Context (nvim-treesitter-context)
      # shows the current scope that the
      # user is programming in.
      context.enable = mkDefault true;
      context.separator = mkDefault "┄";
    };

    /*
    Keybinds. Should be automatically merged from the
    dedicated file, so please don't try and set them
    here manually.
    */
    binds = {
      # Show a cheatsheet. Very, very good and
      # highly recommended for beginners.
      # cheatsheet.enable = mkDefault true;

      # Show key guide on <leader>.
      whichKey = {
        enable = mkDefault true;
        register = {
          "<leader><leader>" = "[] Miscellaneous";

          "<leader>l" = "[] LSP";
          "<leader>g" = "[] Git";

          "<leader>f" = "[] File";
          "<leader>ff" = "Find Files [Telescope]";
          "<leader>fp" = "Find Projects [Telescope]";

          "<leader>b" = "[] Buffer";
          "<leader>bm" = "Move";
          "<leader>bc" = "Pick";
          "<leader>bs" = "Sort";
          "<leader>bn" = "Next";
          "<leader>bp" = "Previous";
          "<leader>bN" = "Move Next";
          "<leader>bP" = "Move Previous";

          "<leader>d" = "[] Debug";
          "<leader>ds" = "[] Step";
          "<leader>dv" = "[] Stacktrace";

          "<leader>c" = "[] Code";
          "<leader>ca" = "Code Actions";
          "<leader>cd" = "Show Cursor Diagnostics";
          "<leader>cD" = "Show Line Diagnostics";
          "<leader>cp" = "Preview Symbol Definition";
          "<leader>cr" = "Rename Symbol Occurrence";
          "<leader>cs" = "Signature Help";
          "<leader>cf" = "Format";

          "<leader>x" = "[] Trouble";
          "<leader>xx" = "Toggle Trouble";
          "<leader>xq" = "Open QuickFix";
          "<leader>xl" = "Open LOC List";

          "<leader>E" = "[] Neovim Tree";
          "<leader>Er" = "Refresh Tree";
          "<leader>Ef" = "Focus Tree";
          "<leader>e" = "Open Tree";

          "<leader>t" = "[] Telescope";
          "<leader>tL" = "[] LSP [Telescope]";
          "<leader>tG" = "[] Git [Telescope]";
          "<leader>tt" = "Open Telescope";
          "<leader>td" = "Open Diagnostics";
          "<leader>tb" = "List Open Buffers";

          "<leader>h" = "Hop";
        };
      };
    };

    languages =
      {
        enableExtraDiagnostics = mkDefault true;
        enableTreesitter = mkDefault true;
        enableFormat = mkDefault true;
        enableLSP = mkDefault true;
        enableDAP = mkDefault true;
      }
      // (import ./langs.nix {inherit lib;});

    /*
    Utility color picker.
    Very good for web-development.
    */
    utility = {
      ccc = {
        enable = mkDefault true;
      };

      /*
      Cycle through diffs for all
      modified files for any git revision.

      "Whodunnit?! Who broke my repository?!" - You, if you need to use this.
      */
      diffview-nvim = {
        enable = mkDefault true;
      };

      /*
      Utility icon picker.
      Very good for Terminal UI (TUI) development.
      */
      icon-picker = {
        enable = mkDefault true;
      };

      /*
      Easier motions.
      Eliminate the mouse.
      */
      motion = {
        # The difference between `hop` and `leap`
        # is the method of which you jump to your keywords.

        # `Hop` is more keystroke-efficient with
        #  randomized-yet-close keystrokes.
        hop = {
          enable = mkDefault true;
          mappings.hop = mkDefault "<leader>h";
        };

        #  `Leap` is more brain-efficient by
        #  using parts of the word.

        #  Because of this, there is also more
        #  fine-tuneable configuration.
        leap = {
          enable = mkDefault false;

          mappings = {
            leapBackwardTill = mkDefault "X";
            leapBackwardTo = mkDefault "S";

            leapForwardTill = mkDefault "x";
            leapForwardTo = mkDefault "s";

            leapFromWindow = mkDefault "gs";
          };
        };
      };

      /*
      Change surrounding characters.
      (quotation marks, apostrophes, asterisks, so on.)
      */
      surround = {
        enable = mkDefault true;
        mappings = {
          change = mkDefault "ysc";
          delete = mkDefault "ds";

          normal = mkDefault "ys";
          normalLine = mkDefault "yss";

          normalCur = mkDefault "yS";
          normalCurLine = mkDefault "ySS";

          visual = mkDefault "s";
          visualLine = mkDefault "S";

          insert = mkDefault "<C-s>i";
          insertLine = mkDefault "<C-s>I";
        };
      };

      /*
      Lightweight project time tracking.
      Looks very good in your portfolio.
      */
      vim-wakatime = {
        enable = mkDefault true;
      };
    };
    maps = let
      windowMovementCommands = {
        "<C-Left>" = mkDefault {
          silent = mkDefault true;
          action = mkDefault "<cmd>wincmd h<cr>";
        };

        "<C-Right>" = mkDefault {
          silent = mkDefault true;
          action = mkDefault "<cmd>wincmd l<cr>";
        };

        "<C-Up>" = mkDefault {
          silent = mkDefault true;
          action = mkDefault "<cmd>wincmd k<cr>";
        };

        "<C-Down>" = mkDefault {
          silent = mkDefault true;
          action = mkDefault "<cmd>wincmd j<cr>";
        };
      };
    in {
      insert = {
        "<esc>" = mkDefault {
          silent = mkDefault true;
          action = "<esc>:noh<cr><esc>";
        };
      };

      terminal = lib.mkMerge [
        windowMovementCommands
        {
        }
      ];

      normal = let
        require = what: index: "require('${what}').${index}";
        resize = direction: ''
          function()
            ${require "smart-splits" "resize_${direction}(${builtins.toString resizeHeight})"}
          end
        '';
        mkLuaBinding = key: action: desc:
          lib.mkIf (key != null) {
            "${key}" = {
              inherit action desc;
              lua = true;
              silent = true;
            };
          };
      in
        mkForce (lib.mkMerge [
          windowMovementCommands

          (mkLuaBinding "<C-k>" (resize "up") "Resize up.")
          (mkLuaBinding "<C-j>" (resize "down") "Resize down.")
          (mkLuaBinding "<C-h>" (resize "left") "Resize left.")
          (mkLuaBinding "<C-l>" (resize "right") "Resize right.")
          {
            "<leader>f" = mkForce {
              action = mkForce "<Nop>";
              desc = mkForce "File";
            };

            "<leader>fs" = mkForce {
              action = mkForce "<cmd>w<cr>";
              desc = mkForce "Save File";
            };

            "<leader>fc" = mkForce {
              action = mkForce "<cmd>bd<cr>";
              silent = mkForce true;
              desc = mkForce "Close File";
            };

            "<leader>ft" = mkForce {
              action = mkForce ''<cmd>ToggleTerm direction="float"<cr>'';
              silent = mkForce true;
              desc = mkForce "Open Floating Terminal";
            };

            "<leader>fT" = {
              action = mkForce ''<cmd>ToggleTerm<cr>'';
              silent = mkForce true;
              desc = mkForce "Open Terminal";
            };
          }
          {
            "<Up>" = mkDefault {
              silent = mkDefault true;
              action = mkDefault no;
            };

            "<Down>" = mkDefault {
              silent = mkDefault true;
              action = mkDefault no;
            };

            "<Left>" = mkDefault {
              silent = mkDefault true;
              action = mkDefault no;
            };

            "<Right>" = mkDefault {
              silent = mkDefault true;
              action = mkDefault no;
            };
          }
          {
            "<leader><leader>" = mkDefault {
              action = "<Nop>";
              desc = "Miscellaneous";
            };
            "<leader><leader>L" = mkDefault {
              silent = mkDefault true;
              action = mkDefault "<cmd>Legendary<cr>";
              desc = "Open Legendary";
            };
          }
          {
            H = mkDefault {
              silent = mkDefault true;
              action = "<cmd>BufferLineCyclePrev<cr>";
            };

            L = mkDefault {
              silent = mkDefault true;
              action = "<cmd>BufferLineCycleNext<cr>";
            };
          }
          {
            gk = mkDefault {
              silent = mkDefault true;
              action = mkDefault "k";
            };
            gj = mkDefault {
              silent = mkDefault true;
              action = mkDefault "j";
            };
            k = mkDefault {
              silent = mkDefault true;
              action = mkDefault "gk";
            };
            j = mkDefault {
              silent = mkDefault true;
              action = mkDefault "gj";
            };
          }
        ]);
    };
  };
}
