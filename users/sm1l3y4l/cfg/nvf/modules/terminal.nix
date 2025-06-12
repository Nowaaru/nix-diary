lib:
{
  normal = {
    "<leader>dtt" = {
      action = "<cmd>ToggleTerm<CR>";
      desc = "Open Terminal";
    };

    "<leader>dtf" = {
      action = "<cmd>ToggleTerm direction=floating<CR>";
      desc = "Floating";
    };

    "<leader>dtv" = {
      action = "<cmd>ToggleTerm direction=vertical<CR>";
      desc = "Right";
    };

    "<leader>dth" = {
      action = "<cmd>ToggleTerm direction=horizontal<CR>";
      desc = "Right";
    };

    "<leader>d^" = {
      action = "<cmd>ToggleTermSendCurrentLine<CR>";
      desc = "Send Hovered Line to Terminal";
    };
  };
}
// (let
  movement = import ./movement.nix;
  splits = import ./splits.nix;
in {
  terminal = {
    inherit (movement.normal) "<C-w>" "<C-s>" "<C-a>" "<C-d>";
    inherit (splits.normal) "<C-S-w>" "<C-S-s>" "<C-S-a>" "<C-S-d>";
  };
})
