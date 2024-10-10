{ pkgs, ... }:

pkgs.writeShellScriptBin "hyprland_exec" ''
  ${pkgs.swww}/bin/swww restore || echo "Failed to set wallpaper"
  ${pkgs.eww}/bin/eww open bar1 || echo "Failed to open bar1"
  ${pkgs.eww}/bin/eww open bar2 || echo "Failed to open bar2"
''
