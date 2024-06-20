{
  config,
  lib,
  ...
}: let
  cfg = config.mihoyo;
in {
  imports = [];

  options = with lib; {
    mihoyo = {
      proxy.enable = mkEnableOption "host redirection for Mihoyo games.";
    };
  };

  config = with lib;
    mkIf (!cfg.proxy.disable) {
      networking.hosts = {
        "0.0.0.0" = [
          "overseauspider.yuanshen.com"
          "log-upload-os.hoyoverse.com"

          "log-upload.mihoyo.com"
          "uspider.yuanshen.com"
          "sg-public-data-api.hoyoverse.com"

          "prd-lender.cdp.internal.unity3d.com"
          "thind-prd-knob.data.ie.unity3d.com"
          "thind-gke-usc.prd.data.corp.unity3d.com"
          "cdp.cloud.unity3d.com"
          "remote-config-proxy-prd.uca.cloud.unity3d.com"
        ];
      };
    };
}
