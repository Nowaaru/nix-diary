{
  lib,
  pkgs,
  ...
}: let
  out = {
    mkUser = username: {
      programs ? [],
      sessionVariables,
      variables ? sessionVariables,
      extraSpecialArgs ? {},
      files ? {},
    }: {
      __ = {inherit extraSpecialArgs;};
      imports = programs;

      home = {
        username = lib.mkForce username;
        homeDirectory = lib.mkForce "/home/${username}";
        sessionVariables = lib.mkMerge [sessionVariables variables];
        stateVersion = lib.mkDefault "24.05";
        file = lib.mkDefault files;
      };

      programs.home-manager.enable = lib.mkForce true;
    };

    mkHomeManager = users: {
      specialArgs ? {},
      cfgRoot ? "cfg",
      usrRoot,
    }: let
    in
      lib.lists.foldl (a: usr:
        a
        // {
          ${usr.home.username.content} = lib.homeManagerConfiguration (let
            _configure = special_args: program_name:
              lib.withInputs "${usrRoot}/${usr.home.username.content}/${cfgRoot}/${program_name}" special_args;

            _extraSpecialArgs =
              specialArgs
              // usr.__.extraSpecialArgs;
          in rec {
            inherit pkgs;
            extraSpecialArgs =
              _extraSpecialArgs
              // {
                configure = _configure (_extraSpecialArgs
                  // {
                    inherit pkgs;
                    inherit (pkgs) lib;
                  });
              };

            modules = [
              (lib.attrsets.filterAttrs (k: _: !(builtins.elem k ["__"])) usr)
              (usrRoot + /${usr.home.username.content})
            ];
          });
        }) {}
      users;
  };
in
  out
