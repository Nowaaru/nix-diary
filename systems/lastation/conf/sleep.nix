{ lib, ...}: {
  systemd.targets = {
    # this shit makes my pc un-wakeable after some time and i have to FULLY switch that mf off so nah
    sleep.enable = lib.mkForce false;
    suspend.enable = lib.mkForce false; 
    hibernate.enable = lib.mkForce false;
    hybrid-sleep.enable = lib.mkForce false;
  };
}
