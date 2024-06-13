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

    extraDiagnostics.types = ["eslint_d"];
  };

  lua = {
    enable = true;
    lsp.neodev.enable = true;
  };

  nix.enable = true;
  bash.enable = true;
}
