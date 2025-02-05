toplevel @ {
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
      system,
    }: {
      # TODO: omit this hacky  ass way and
      # use the home-modules/systemic-home-manager
      # module to enable home.system = "x86_64-linux"
      __ = {inherit extraSpecialArgs system;};
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
      lib.lists.foldl (a: usr: {
        imports =
          a.imports
          ++ [
            {
              flake.homeConfigurations.${usr.home.username.content} = lib.homeManagerConfiguration (let
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
                  if (lib.traceVal _extraSpecialArgs) ? "pkgs"
                  then builtins.trace "using special pkgs" _extraSpecialArgs.pkgs
                  # TODO: instead of using import pkgs, pass withSystem as the initial argument
                  # and then allow that to be used instead
                  else builtins.trace "using toplevel pkgs" (lib.withSystem usr.__.system ({self', ...}: self'.legacyPackages.default));
              in {
                pkgs = builtins.trace _pkgs.lib.gamindustri _pkgs;
                extraSpecialArgs =
                  _extraSpecialArgs
                  // {
                    # directory for user data (like meta.nix, cfg, programs...)
                    root = /${usrRoot}/${usr.home.username.content};
                    # function to read .nix files from designated cfg directory (else system fallback)
                    configure = _configure (
                      {
                        pkgs = _pkgs;
                        inherit (_pkgs) lib;
                      }
                      // _extraSpecialArgs
                    );
                    programs = libprograms.mkProgramTreeFromDir programs-dir;
                    user = let
                      name = usr.home.username.content;
                      usr-programs-dir = /${usrRoot}/${name}/programs;
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
                  /${usrRoot}/${usernameContent}
                ];
              });
            }
          ];
      }) {
        imports = [];
      }
      users;
  };
in
  out
