{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jetbrains.rider
    dotnet-aspnetcore_8
  ];
}
