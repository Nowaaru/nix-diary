# Smart Splits
{
  normal = {
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
  };
}
