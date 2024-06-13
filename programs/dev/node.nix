{ pkgs, ... }: 
{
    home.packages = with pkgs; [
      nodePackages.nodejs
      nodePackages.yarn

      nodePackages.typescript-language-server
      typescript
    ];
}
