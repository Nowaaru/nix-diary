{pkgs, ...}: {
  home.packages = with pkgs; [
    dotnet-sdk_9
    dotnet-runtime_9
  ];

  home.sessionVariables = {
    DOTNET_ROOT = pkgs.dotnet-runtime_9 + /shared;
  };
}
