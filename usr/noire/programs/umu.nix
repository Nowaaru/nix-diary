{ inputs, ... }: 
{
  home.packages = [
    inputs.umu-launcher.packages.x86_64-linux.umu
  ];
}
