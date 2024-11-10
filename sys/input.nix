{
  /*
   * Windows Sensitivity  Multiplier
   * http://www.notalent.org/sensitivity/sensitivity.htm 
   
   * 1/11                 0.0625
   * 2/11                 0.0125
   * 3/11                 0.025
   * 4/11                 0.5
   * 5/11                 0.075
   * 6/11 (Default)       1.0
   * 7/11                 1.5
   * 8/11                 2.0
   * 9/11                 2.5
   * 10/11                3.0
   * 11/11                3.5
  */
  services.libinput = {
    enable = true;
    mouse = {
      accelSpeed = "-0.75"; # 5/11 
      accelProfile = "flat";

      middleEmulation = false;
      scrollButton = 2;
    };
  };
}
