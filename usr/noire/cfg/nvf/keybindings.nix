lib: 
  rec {
    # ToggleTerm Stuff
    normal = {
      "<leader>tt" = {
        action = "<cmd>ToggleTerm<CR>";
        desc = "Open Terminal";
      };

      "<leader>tf" = {
        action = "<cmd>ToggleTerm direction=floating<CR>";
        desc = "Floating";
      };

      "<leader>tv" = {
        action = "<cmd>ToggleTerm direction=vertical<CR>";
        desc = "Right";
      };

      "<leader>th" = {
        action = "<cmd>ToggleTerm direction=horizontal<CR>";
        desc = "Right";
      };

      "<leader>tT" = {
        action = "<cmd>ToggleTermSendCurrentLine<CR>";
        desc = "Send Hovered Line to Terminal";
      };

      # Bufferline Stuff
      "<C-Tab>" = {
        action = "<cmd>BufferLineCycleNext<CR>";
        desc = "Cycle to Next Buffer";
      };

      "<C-S-Tab>" = {
        action = "<cmd>BufferLineCyclePrev<CR>";
        desc = "Cycle to Previous Buffer";
      };

      "<leader>bsd" = {
        action = "<cmd>BufferLineSortByRelativeDirectory<CR>";
        desc = "Sort By Relative Directory";
      };

      "<leader>bsD" = {
        action = "<cmd>BufferLineSortByDirectory<CR>";
        desc = "Sort By Absolute Directory";
      };

      "<leader>bse" = {
        action = "<cmd>BufferLineSortByExtension<CR>";
        desc = "Sort By Extension";
      };

      "<leader>bst" = {
        action = "<cmd>BufferLineSortByTabs<CR>";
        desc = "Sort By Tab ID";
      };

      "<leader>bP" = {
        action = "<cmd>BufferLineTogglePin<CR>";
        desc = "Pin Current Buffer";
      };

      "<leader>bp" = lib.mkForce {
        action = lib.mkForce "<cmd>BufferLineTogglePick<CR>";
        desc = lib.mkForce "Pick Buffer";
      };

      "<leader>bsr" = {
        action = "<cmd>BufferLineTabRename<CR>";
        desc = "Rename Current Buffer";
      };
      
      "<leader>qq" = {
        action = "<cmd>qa";
        desc = "Close NeoVim";
      };

      "<leader>bd" = {
        action = "<cmd>Bdelete<CR>";
        desc = "Close Current Buffer";
      };

      "<leader>bD" = {
        action = "<cmd>BufferLineCloseOthers<CR>";
        desc = "Close Other Buffers";
      };

      "<leader>b<C-d>" = {
        action = "<cmd>BufferLineCloseOthers<CR>";
        desc = "Close Other Buffers";
      };

      "<C-S-h>" = {
        action = "<cmd>BufferLineMovePrev<CR>";
      };

      "<C-S-l>" = {
        action = "<cmd>BufferLineMoveNext<CR>";
      };

      "<S-h>" = {
        action = "<cmd>BufferLineCyclePrev<CR>";
      };

      "<S-l>" = {
        action = "<cmd>BufferLineCycleNext<CR>";
      };

      # Movement Stuff
      j = {
        action = "gj";
      };

      k = {
        action = "gk";
      };

      # Smart Splits
      "<C-S-a>" = {
        action = "require('smart-splits').resize_left";
        lua = true;
      };

      "<C-S-w>" = {
        action = "require('smart-splits').resize_up";
        lua = true;
      };

      "<C-S-s>" = {
        action = "require('smart-splits').resize_down";
        lua = true;
      };

      "<C-S-d>" = {
        action = "require('smart-splits').resize_right";
        lua = true;
      };

      "<M-w>" = {
        action = "<C-w>";
      };

      "<C-w>" = {
        action = "require('smart-splits').move_cursor_up";
        lua = true;
      };
      "<C-s>" = {
        action = "require('smart-splits').move_cursor_down";
        lua = true;
      };
      "<C-a>" = {
        action = "require('smart-splits').move_cursor_left";
        lua = true;
      };
      "<C-d>" = {
        action = "require('smart-splits').move_cursor_right";
        lua = true;
      };

      # LSP Stuff
      "gd" = {
        action = "<leader>lgd";
        noremap = false;
      };

      "gt" = {
        action = "<leader>lgt";
        noremap = false;
      };

      "<F12>" = {
        action = "<leader>lgD";
        noremap = false;
      };
    };

    terminal = {
      inherit (normal) "<C-w>" "<C-s>" "<C-a>" "<C-d>";
      inherit (normal) "<C-S-w>" "<C-S-s>" "<C-S-a>" "<C-S-d>";
    };

    visual = {
      inherit (normal) k j;
      "<leader>t" = {
        action = "<cmd>ToggleTermSendVisualSelection<CR>";
        desc = "Send Selection to Terminal";
      };
      "<leader>T" = {
        action = "<cmd>ToggleTermSendVisualLines<CR>";
        desc = "Send Lines to Terminal";
      };
    };

    insert = {};
  }
