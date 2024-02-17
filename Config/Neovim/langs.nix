{lib}: let
  inherit (lib) mkDefault mkForce;
  useLanguage = withWhat: languageId: let
    languageTemplate = {
      enable = mkDefault true;
    };
  in {
    ${languageId} = lib.lists.foldl' (acc: cur: (cur acc)) languageTemplate withWhat;
  };

  withLsp = what:
    what
    // {
      lsp.enable = true;
    };

  withDiagnostics = diagnostics: what:
    what
    // {
      extraDiagnostics = {
        enable = mkDefault true;
        types = mkDefault diagnostics;
      };
    };

  withFormatting = what:
    what
    // {
      format.enable = mkDefault true;
    };

  withTreesitter = what:
    what
    // {
      treesitter.enable = mkDefault true;
    };

  withDebug = what:
    what
    // {
      dap.enable = mkDefault true;
    };

  withOverrides = overrides: what:
    what // overrides;

  mkForceful = what: (mkForce what);
in (lib.lists.foldl (acc: cur: acc // cur) {} [
  (useLanguage [withLsp withFormatting withTreesitter (withDiagnostics ["statix" "deadnix"])] "nix")
  (useLanguage [withLsp withTreesitter withFormatting (withDiagnostics ["shellcheck"])] "bash")
  (useLanguage [withLsp withDebug withTreesitter] "clang")

  (useLanguage [withTreesitter] "html")
  (useLanguage [withLsp withTreesitter] "css")

  (useLanguage [withLsp withTreesitter] "java")
  (useLanguage [withLsp withTreesitter] "markdown")

  (useLanguage [
    withLsp
    withFormatting
    withTreesitter
    (withDiagnostics ["eslint_d"])
    (withOverrides {
      lsp.server = "tsserver";
      format.type = "prettierd";
    })
  ] "ts")

  (useLanguage [withLsp withFormatting withTreesitter (withDiagnostics ["sqlfluff"])] "sql")

  (useLanguage [
    withLsp
    withTreesitter
    (withOverrides {
      lsp.neodev.enable = true;
    })
  ] "lua")

  (useLanguage [
    withLsp
    withDebug
    withTreesitter
    (withOverrides {
      crates.enable = true;
    })
  ] "rust")
])
