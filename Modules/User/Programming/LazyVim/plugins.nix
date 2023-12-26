{pkgs, ...}: 
  with pkgs.vimPlugins; let
    treesitter-parsers = with nvim-treesitter-parsers; [
      # Shell.
      fish
      bash


      # Meta languages.
      nix
      lua
      vim
      vimdoc
      
      # Programming.
      c_sharp
      rust
      luau
      scss

      # Web development.
      html
      css

      javascript
      typescript
      tsx

      # Settings.
      yaml
      ini
      json
      json5
      jsonc
      git_config
  ];
  neovim-plugins = [
  ];
  in [ nvim-treesitter ] ++ treesitter-parsers ++ neovim-plugins
  

