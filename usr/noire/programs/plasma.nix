{ inputs, configure, ... }: 
{
  imports = [inputs.plasma-manager.homeManagerModules.plasma-manager];
  
  programs.plasma = configure "plasma";
}
