{ pkgs, ... }: 
{
    home.packages = with pkgs; [
      nodePackages.nodejs
    ];
}
