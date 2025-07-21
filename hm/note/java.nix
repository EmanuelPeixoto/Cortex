{ pkgs, ... }:
{
  programs.java = {
    enable = true;
    package = pkgs.openjdk23.override { enableJavaFX = true; };
  };
}
