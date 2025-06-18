{ config, pkgs, ... }:
let
  wallpaper = import ./wallpaper.nix { inherit config pkgs; };
in
pkgs.writeShellScriptBin "hyprland_exec" ''
  ${pkgs.swww}/bin/swww restore || echo "Failed to set wallpaper"
  ${wallpaper}/bin/wallpaper || echo "Failed to change wallpaper"
''
