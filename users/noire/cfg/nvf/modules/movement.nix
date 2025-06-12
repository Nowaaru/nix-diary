rec {
  normal = {
    j = {
      action = "gj";
    };

    k = {
      action = "gk";
    };

    "<M-w>" = {
      action = "<C-w>";
      desc = "Split Selection";
    };

    "<C-w>" = {
      action = "require('smart-splits').move_cursor_up";
      desc = "Move Cursor to Upward Split";
      lua = true;
    };
    "<C-s>" = {
      action = "require('smart-splits').move_cursor_down";
      desc = "Move Cursor to Downward Split";
      lua = true;
    };
    "<C-a>" = {
      action = "require('smart-splits').move_cursor_left";
      desc = "Move Cursor to Left Split";
      lua = true;
    };
    "<C-d>" = {
      action = "require('smart-splits').move_cursor_right";
      desc = "Move Cursor to Left Right";
      lua = true;
    };
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
}
