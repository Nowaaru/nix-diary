{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dotnet-sdk
    dotnet-sdk_7
    dotnet-sdk_8

    dotnet-runtime
    dotnet-runtime_7
    dotnet-runtime_8
  ];
}
