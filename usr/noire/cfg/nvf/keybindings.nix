let
  k = {
    action = "gk";
  };
  j = {
    action = "gj";
  };
in rec {
  normal = {
    inherit k j;
    "<C-j>" = {
      action = "J";
    };

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
  };

  terminal = {
    inherit (normal) "<C-w>" "<C-s>" "<C-a>" "<C-d>";
    inherit (normal) "<C-S-w>" "<C-S-s>" "<C-S-a>" "<C-S-d>";
  };

  visual = {
    inherit k j;
  };

  insert = {
    "gd" = {
      action = "<Esc>";
    };
  };
}
