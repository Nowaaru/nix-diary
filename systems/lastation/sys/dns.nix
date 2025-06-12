{lib, ...}: {
  networking = let
    nameServers = lib.mkForce [
      "127.0.0.1"
      "127.0.0.1:53"
      "127.0.0.1:4000"
    ];
  in {
    hostName = "lastation"; # Define your hostname.

    networkmanager = {
      enable = lib.mkForce true;
      dns = lib.mkForce "systemd-resolved";
      insertNameservers = lib.mkForce [
        "127.0.0.1"
        "127.0.0.1:53"
        "127.0.0.1:4000"
      ];
    };

    nameservers = lib.mkForce [
      "127.0.0.1"
      "127.0.0.1:53"
      "127.0.0.1:4000"
    ];

    firewall = {
      allowedTCPPorts = [25565];
      allowedTCPPortRanges = [
        # Rojo
        {
          from = 34872;
          to = 34876;
        }
        # Steam
        {
          from = 27015;
          to = 27030;
        }
      ];
      allowedUDPPorts = [
        # Steam
        3478
      ];
      allowedUDPPortRanges = [
        # Steam
        {
          from = 27015;
          to = 27030;
        }
        {
          from = 27031;
          to = 27100;
        }
        {
          from = 4379;
          to = 4380;
        }
      ];
    };
  };
}
