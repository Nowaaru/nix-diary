{
  lib,
  pkgs,
  self,
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
    }:
      lib.lists.foldl (a: usr:
        a
        // {
          ${usr.home.username.content} = lib.homeManagerConfiguration (let
            _configure = special_args: program_name: let
              reqCfgDir = "${usrRoot}/${usr.home.username.content}/${cfgRoot}/${program_name}";
              fallbackCfgDir = "${self}/cfg/${program_name}";
              chosenPath =
                if builtins.pathExists reqCfgDir
                then reqCfgDir
                else if builtins.pathExists fallbackCfgDir
                then fallbackCfgDir
                else abort "configuration '${program_name}' does not exist as ${reqCfgDir} or '${fallbackCfgDir}'";
            in
              lib.withInputs chosenPath special_args;

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
