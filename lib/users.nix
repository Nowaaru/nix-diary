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
      files ? {},
    }: {
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
      extraSpecialArgs ? {},
      usrRoot,
    }:
      lib.lists.foldl (a: usr:
        a
        // {
          ${usr.home.username.content} = lib.homeManagerConfiguration {
            inherit extraSpecialArgs pkgs;
            modules = [
              usr
              (usrRoot + /${usr.home.username.content})
            ];
          };
        }) {}
      users;
  };
in
  out
