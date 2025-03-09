pkgs: {
  enableExtraDiagnostics = true;
  enableTreesitter = true;
  enableFormat = true;
  enableLSP = true;
  enableDAP = true;

  rust = {
    enable = true;
    crates = {
      enable = true;
      codeActions = true;
    };
  };

  ts = {
    enable = true;
    format.enable = true;
    # format = {
    #   package = pkgs.dprint;
    # };

    extraDiagnostics.types = [];
  };

  lua = {
    enable = true;
    lsp.neodev.enable = true;
  };
  nix = {
    enable = true;
    lsp.server = "nixd";
  };

  python.enable = true;
  bash.enable = true;
  css.enable = true;
}
