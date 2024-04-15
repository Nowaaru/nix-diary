{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    ncmpcpp
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
