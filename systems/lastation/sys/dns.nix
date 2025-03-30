{lib, ...}: {
  networking = let
    nameServers = lib.mkForce [
      "192.168.0.165"
      "192.168.0.165:53"
      "192.168.0.165:4000"
    ];
  in {
    hostName = "lastation"; # Define your hostname.

    networkmanager = {
      enable = lib.mkForce true;
      dns = lib.mkForce  "systemd-resolved";
      insertNameservers = lib.mkForce [
        "192.168.0.165"
        "192.168.0.165:53"
        "192.168.0.165:4000"
      ];
    };

    nameservers = lib.mkForce [
      "192.168.0.165"
      "192.168.0.165:53"
      "192.168.0.165:4000"
    ];

    firewall = {
      allowedTCPPorts = [25565];
      allowedTCPPortRanges = [
        {
          from = 34872;
          to = 34876;
        }
      ];
      allowedUDPPorts = [];
    };
  };
}
