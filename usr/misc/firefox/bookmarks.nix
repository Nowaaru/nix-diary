{lib}: let
  verifyList = what: tags:
    if (lib.assertMsg (builtins.isList what) "expected list, got ${builtins.typeOf what}")
    then what ++ tags
    else [];

  withSocial = tags:
    verifyList tags ["social"];

  withNeovim = tags:
    verifyList tags ["neovim" "nvim" "vim"];

  withNix = tags:
    verifyList tags ["nix" "nixos"];

  withPkgs = tags:
    verifyList tags ["packages"];

  withDocs = tags:
    verifyList tags ["documentation"];

  withRoblox = tags:
    verifyList tags ["roblox" "lua"];

  withForums = tags:
    ["forum" "forums"] ++ (withSocial tags);
in [
  {
    name = lib.mkForce "Toolbar";
    toolbar = lib.mkForce true;
    bookmarks = [
      {
        name = "NixOS";
        bookmarks = [
          {
            name = "MyNixOS - Nix Option Helper";
            url = "https://www.mynixos.com";
            tags = withNix (withPkgs ["options"]);
            keyword = "mno";
          }
          {
            name = "NixOS Package Search";
            url = "https://search.nixos.org/packages";
            tags = withNix (withPkgs []);
            keyword = "packages";
          }
          {
            name = "Nowaaru/nix-diary: 🐶";
            url = "https://github.com/Nowaaru/nix-diary";
            tags = withNix (withPkgs ["diary"]);
            keyword = "diary";
          }
        ];
      }
      {
        name = "Programming";
        bookmarks = [
          {
            name = "Preface | Nixpkgs Manual";
            url = "https://ryantm.github.io/nixpkgs#preface";
            tags = ["nix" "nixos" "nixpkgs" "documentation" "programming"];
            keyword = "nixpkgs";
          }
          {
            name = "Roblox Developer Forum";
            url = "https://www.devforum.roblox.com";
            tags = withRoblox (withForums ["devforum"]);
            keyword = "devforum";
          }
          {
            name = "Roblox";
            url = "https://www.create.roblox.com";
            tags = withRoblox [];
            keyword = "roblox";
          }
        ];
      }
      {
        name = "Configuration";
        bookmarks = [
          {
            name = "Neovim";
            bookmarks = [
              {
                name = "Home";
                url = "https://neovim.io/doc/";
                tags = withNeovim (withDocs []);
              }
              {
                name = "Plugins";
                url = "https://dotfyle.com/neovim/plugins/trending";
                tags = withNeovim ["plugins"];
              }
              {
                name = "Keymaps / Keymapping";
                url = "https://neovim.io/doc/user/usr_40.html#40.1";
                tags = withNeovim (withDocs []);
              }
            ];
          }
          {
            name = "Neovim Flake";
            url = "https://jordanisaacs.github.io/neovim-flake";
            tags = withNix (withNeovim ["flake" "configuration" "documentation" "programming"]);
          }
        ];
      }
      {
        name = "Proton";
        url = "https://mail.proton.me/u/0/inbox";
        tags = withSocial ["proton" "mail" "email"];
        keyword = "proton";
      }
    ];
  }
]
