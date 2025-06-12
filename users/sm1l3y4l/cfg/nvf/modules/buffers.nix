# Bufferline Stuff
lib: rec {
  normal = {
    "<C-,>" = {
      action = "<cmd>BufferLineMovePrev<CR>";
    };

    "<C-.>" = {
      action = "<cmd>BufferLineMoveNext<CR>";
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

    "<leader>bsi" = {
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

    "<leader>br" = {
      action = "<cmd>BufferLineTabRename<CR>";
      desc = "Rename Current Buffer";
    };

    "<leader>bd" = {
      action = "<cmd>Bdelete<CR>";
      desc = "Close Current Buffer";
    };

    "<leader>bD" = {
      action = "<cmd>BufferLineCloseOthers<CR>";
      desc = "Close Other Buffers";
    };

    "<leader>bm" = {
      action = "<noop>";
      desc = null;
    };
  };
}
