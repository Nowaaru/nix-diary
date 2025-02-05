{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    rojo
  ];
}
