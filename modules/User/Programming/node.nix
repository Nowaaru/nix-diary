{ pkgs, ... }: 
{
    home.packages = with pkgs; [
      nodePackages.nodejs
      nodePackages.yarn

      typescript
    ];
}
