{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alsa-utils
  ];

  # https://forums.fedoraforum.org/showthread.php?256851-No-sound-when-using-Nvidia-hdmi&s=d47566171fa22b0ce0eaf714ba9cacd0&p=1435094#post1435094
  /*
  MNKyDeth  (15th January, 2011 - 01:51 PM):

  To try and help the above poster these are the steps I took.

  In a terminal type "alsamixer -V all" without the quotes.
  Go to your hdmi device by hitting F6 and then selecting the device. Every thing you see in there make sure you unmute them. M = mute and 00 = unmute.

  Next you need to find witch channel the audio is running on.
  typing cat /proc/asound/card0/eld#3.0 <-- change the card0 to the hdmi card. Then cat each eld# until you find the one that has you're monitor listed in it. Mine said LG TV on the third line from the top as an example.

  Once you found the monitor listed you will then need to use one of these eld#0.0 -> 0x101, eld#1.0 -> 0x102, eld#2.0 -> 0x104, eld#3.0 -> 0x108

  Open up /etc/modprobe.d/dist-alsa.conf
  Add a line similar to this.
  options snd-hda-intel enable_msi=0 probe_mask=0x108

  Change the probe_mask=(this) to the appropriate number for you're setup.

  Worse case scenario you could just try all four set of numbers one at a time until it works. Make sure to reboot after each change to make sure they take effect. For my piece of mind I did one extra reboot to make sure I didn't lose the audio.
  */
  boot.extraModprobeConfig = ''
    options snd-hda-intel enable_msi=0 probe_mask=0x101
  '';

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    audio.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;

    extraConfig = {
      # pipewire = {
      #   "92-low-latency" = {
      #     "context.properties" = {
      #       "default.clock.rate" = 48000;
      #       "default.clock.quantum" = 32;
      #       "default.clock.min-quantum" = 32;
      #       "default.clock.max-quantum" = 32;
      #     };
      #   };
      # };
      pipewire-pulse = {
        # "92-low-latency" = {
        #   context.modules = [
        #     {
        #       name = "libpipewire-module-protocol-pulse";
        #       args = {
        #         pulse.min.req = "32/48000";
        #         pulse.default.req = "32/48000";
        #         pulse.max.req = "32/48000";
        #         pulse.min.quantum = "32/48000";
        #         pulse.max.quantum = "32/48000";
        #       };
        #     }
        #   ];
        #   stream.properties = {
        #     node.latency = "32/48000";
        #     resample.quality = 1;
        #   };
        # };

        "91-monitor-mag272r-rename" = {
          "pulse.properties.rules" = [
            {
              matches = [
                {
                  # 0x1022 found from `pactl list cards` (vendor id)
                  "device.product.id" = "0x1487";
                  # "device.vendor.id" = "0x1022";
                }
              ];
              actions = {
                update-props = {
                  "device.nick" = "MSI MAG272R";
                  "device.description" = "MSI MAG272R";
                  "device.product.name" = "MSI MAG272R";
                };
              };
            }
          ];
        };
      };
    };

    wireplumber = {
      enable = true;
      configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/10-hdmi.conf" ''
          monitor.alsa.rules = [
            {
              matches = [
                {
                  device.name = "alsa_output.pci-0000_0a_00.1.hdmi-stereo"
                }
              ]
              actions = {
                update-props = {
                   node.description = "Test Output"
                }
              }
            }
          ]
        '')
      ];
    };
  };
}
