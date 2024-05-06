{
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    ncmpcpp
    spotify
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      # Add additional package names here
      "spotify"
    ];

  services = {
    mpd = {
      enable = true;
    };

    mpd.extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire 01"
      }
    '';
  };
}
