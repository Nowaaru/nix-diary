{ inputs, ... }: 
{
  hardware.openrazer = {
    enable = true;
    keyStatistics = true;

    batteryNotifier.enable = true;
    devicesOffOnScreensaver = true;

    users = 
      # do not add users that don't actually exist in /home/
      builtins.filter 
        (elem: builtins.pathExists "/home/${elem}")
        (builtins.attrNames (builtins.readDir (inputs.self + /usr)));
  };
}
