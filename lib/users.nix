{
  lib,
  pkgs,
  self,
  ...
}: let
  libprograms = import ./programs.nix lib;
  st = w: builtins.trace w w;
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
              mkCfgDir = cfgDir:
                if builtins.pathExists cfgDir
                then cfgDir
                else
                  (
                    if (builtins.pathExists (cfgDir + ".nix"))
                    then cfgDir + ".nix"
                    else cfgDir
                  );
              reqCfgDir = mkCfgDir "${usrRoot}/${usr.home.username.content}/${cfgRoot}/${program_name}";
              fallbackCfgDir = mkCfgDir "${self}/cfg/${program_name}";
              reqExists = builtins.pathExists reqCfgDir;
              fallbackExists = builtins.pathExists fallbackCfgDir;
            in
              if reqExists && fallbackExists
              then (lib.withInputs fallbackCfgDir special_args) // (lib.withInputs reqCfgDir special_args)
              else
                (
                  if reqExists
                  then (lib.withInputs reqCfgDir special_args)
                  else
                    (
                      if fallbackExists
                      then lib.withInputs fallbackCfgDir special_args
                      else abort "configuration '${program_name}' does not exist as '${reqCfgDir}[.nix]' or '${fallbackCfgDir}[.nix]'"
                    )
                );

            _extraSpecialArgs =
              specialArgs
              // usr.__.extraSpecialArgs;

            programs-dir = self + /programs;

            _pkgs = 
              if _extraSpecialArgs ? "pkgs"
              then _extraSpecialArgs.pkgs
              else pkgs;
          in rec {
            pkgs = _pkgs;
            extraSpecialArgs =
              _extraSpecialArgs
              // {
                configure = _configure (
                  {
                    inherit pkgs;
                    inherit (pkgs) lib;
                  }
                  // _extraSpecialArgs
                );
                programs = libprograms.mkProgramTreeFromDir programs-dir;
                user = let
                  name = usr.home.username.content;
                  usr-programs-dir = self + /usr/${name}/programs;
                in {
                  inherit name;
                  programs =
                    if (builtins.pathExists usr-programs-dir)
                    then (libprograms.mkProgramTreeFromDir usr-programs-dir)
                    else {};
                };
              };

            modules = let
              usernameContent = usr.home.username.content;
            in [
              # patches below
              {
                # patch to add application .desktop files
                # automatically to launchers and things
                xdg.systemDirs.data = ["/home/${usernameContent}/.local/state/nix/profiles/home-manager/home-path/share/applications/"];
              }

              (lib.attrsets.filterAttrs (k: _: !(builtins.elem k ["__"])) usr)
              (usrRoot + /${usernameContent})
            ];
          });
        }) {}
      users;
  };
in
  out
