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
              chosenPath =
                # i already check if the path exists
                # but my brain is blanking on how to otherwise make errors
                # dynamic and verbose while not doing the exists checks
                if builtins.pathExists reqCfgDir
                then reqCfgDir
                else if builtins.pathExists fallbackCfgDir
                then fallbackCfgDir
                else abort "configuration '${program_name}' does not exist as '${reqCfgDir}[.nix]' or '${fallbackCfgDir}[.nix]'";
            in
              lib.withInputs chosenPath special_args;

            _extraSpecialArgs =
              specialArgs
              // usr.__.extraSpecialArgs;

            programs-dir = self + /programs;
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

            modules = [
              {
                xdg.systemDirs.data = ["/home/${usr.home.username.content}/.local/state/nix/profiles/home-manager/home-path/share/applications/"];
              }
              (lib.attrsets.filterAttrs (k: _: !(builtins.elem k ["__"])) usr)
              (usrRoot + /${usr.home.username.content})
            ];
          });
        }) {}
      users;
  };
in
  out
