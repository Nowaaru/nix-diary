{  configure, ... }: 
{
  programs.git = {
    extraConfig = configure "git";
    enable = true;
  };
}
