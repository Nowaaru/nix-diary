lib: let
  out = {
    mkUser = username: {
      programs,
      sessionVariables,
      variables ? sessionVariables,
      source ? null,
      files ? {},
    }: {
      home = {
        inherit username source;
        homeDirectory = "/home/${username}";
        sessionVariables = sessionVariables // variables;
        file = files;

        imports = programs;
      };
      programs.home-manager.enable = true;
    };

    mkHomeManager = {extraSpecialArgs}:
      lib.lists.foldl (a: b:
        a
        // {
          ${b.username} = lib.homeManagerConfiguration {
            inherit extraSpecialArgs;
            modules = [
              (lib.mkIf (b.source != null) b.source)
              b
            ];
          };
        }) {};
  };
in
  out
