{ config, pkgs, ... }:
let
  wallpaper = import ./wallpaper.nix { inherit config pkgs; };
in
pkgs.writeShellScriptBin "hyprland-exec" ''
  ${pkgs.awww}/bin/awww restore || echo "Failed to set wallpaper"
  ${wallpaper}/bin/wallpaper || echo "Failed to change wallpaper"
''
