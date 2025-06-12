inputs: pkgs: {
  enableExtraDiagnostics = true;
  enableTreesitter = true;
  enableFormat = true;
  enableLSP = true;
  enableDAP = true;

  rust = {
    enable = true;
    # FIXME: https://github.com/gbprod/none-ls-shellcheck.nvim
    format.enable = pkgs.lib.mkForce false;
    crates = {
      enable = true;
      codeActions = true;
    };
  };

  # FIXME: https://github.com/gbprod/none-ls-shellcheck.nvim
  # markdown = {
  #   enable = true;
  #   extensions = {
  #     render-markdown-nvim.enable = true;
  #   };
  # };

  ts = {
    enable = true;
    format.enable = true; 
    extraDiagnostics.types = [];
  };

  lua = {
    enable = true;
    lsp.lazydev.enable = true;
  };

  nix = {
    enable = true;
    lsp = {
        server = "nixd";
        options = {
            # nixpkgs.expr = ''(builtins.getFlake ${pkgs.lib.escapeShellArg inputs.self}).outputs.legacyPackages.${inputs.system}.default'';
            nixos.expr = ''(builtins.getFlake ${pkgs.lib.escapeShellArg inputs.self}).nixosConfigurations.options'';
            home_manager.expr = ''(builtins.getFlake ${pkgs.lib.escapeShellArg inputs.self}).homeConfigurations.noire.options'';
            flake-parts-debug.expr = ''(builtins.getFlake ${pkgs.lib.escapeShellArg inputs.self}).debug.options'';
            flake-parts-per-system.expr = ''(builtins.getFlake ${pkgs.lib.escapeShellArg inputs.self}).currentSystem.options'';
        };
    };
  };

  python.enable = true;

  # TODO - add this: https://github.com/gbprod/none-ls-shellcheck.nvim
  bash.enable = false;
  css.enable = true;
}
