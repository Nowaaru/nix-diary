toplevel @ {
  lib,
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
      modules ? [],
      system,
    }: {
      # TODO: omit this hacky  ass way and
      # use the home-mousersdules/systemic-home-manager
      # module to enable home.system = "x86_64-linux"
      __ = {inherit extraSpecialArgs system modules;};
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
    }: {
      flake.homeConfigurations =
        lib.lists.foldl (
          a: usr:
            a
            // {
              ${usr.home.username.content} = lib.withSystem usr.__.system ({
                  config,
                  inputs',
                  self',
                  system,
                  pkgs,
                  ...
                } @ ctx:
                  lib.homeManagerConfiguration (let
                    _configure = special_args: pre_program_name: let
                      program_name = lib.strings.replaceChars ["\\." "."] ["." "/"] pre_program_name;

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
                      else self'.legacyPackages.default;
                  in {
                    pkgs = _pkgs;
                    extraSpecialArgs =
                      _extraSpecialArgs
                      // rec {
                        inherit inputs' self' self;
                        # directory for user data (like meta.nix, cfg, programs...)
                        root = /${usrRoot}/${usr.home.username.content};
                        # function to read .nix files from designated cfg directory (else system fallback)
                        configure = _configure (
                          {
                            pkgs = _pkgs;
                            inherit (_pkgs) lib;
                            inherit configure;
                            
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

                          # programs = import /${self}/programs (args
                          #   // specialArgs
                          #   // {
                          #     inherit (/* localFlake.lib.traceVal */ pkgs) config;
                          #     inherit (lib) withSystem;
                          #   });
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

                      # automatically setup wineprefix and other environment variables
                      {
                        home.sessionVariables = {
                          GAMES_DIR = lib.mkDefault "/home/${usernameContent}/Games";
                          WINEPREFIX = lib.mkDefault "/home/${usernameContent}/.wine";
                        };
                      }

                      (lib.attrsets.filterAttrs (k: _: !(builtins.elem k ["__"])) usr)
                      (lib.traceVal /${usrRoot}/${usernameContent})
                    ] ++ usr.__.modules;
                  }));
            }
        ) {}
        users;
    };
  };
in
  out
