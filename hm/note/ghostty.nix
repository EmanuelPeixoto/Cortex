{ pkgs, ... }:
{
  home.packages = [
    pkgs.ghostty
  ];

  home.file.".config/ghostty/config".text = ''
    theme = "Builtin Dark"
    focus-follows-mouse = true
    font-family = "MesloLGS Nerd Font"
  '';
}
