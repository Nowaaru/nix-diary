{ inputs, lib, configure, ... }: 
{
  imports = [
    inputs.plasma-manager.homeManagerModules.plasma-manager
    (inputs.self + /home-modules/plasma)
  ];
  
  programs.plasma = configure "plasma";

  xdg.portal.enable = true; 
}
