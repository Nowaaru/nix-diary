{pkgs, ...}: {
  home.packages = with pkgs; [
    nodePackages.typescript-language-server
    typescript
  ];
}
