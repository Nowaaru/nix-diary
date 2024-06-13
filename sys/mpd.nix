{
  inputs,
  pkgs,
  ...
}: {
  services = {
    mpd = {
      enable = true;
    };

    mopidy = let
      mopidySecrets = inputs.secrets.mopidy;
    in {
      enable = true;
      extensionPackages = with pkgs; [
        mopidy-mpd
        mopidy-local
        mopidy-spotify
        mopidy-podcast
        mopidy-ytmusic
        mopidy-youtube
        mopidy-scrobbler
        mopidy-soundcloud
      ];
      configuration = ''
        [mpd]
        enabled=true
        hostname=:: # Scary!
        ${mopidySecrets.spotify}
        ${mopidySecrets.youtube}
      '';
    };
  };
}
