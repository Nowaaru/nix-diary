_: {
  systemd.targets = {
    sleep.enable = true;
    suspend.enable = false; # this shit makes my pc un-wakeable after some time and i have to FULLY switch that mf off so nah
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };
}
