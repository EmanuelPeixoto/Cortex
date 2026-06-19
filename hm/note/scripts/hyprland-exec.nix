{ config, pkgs, ... }:
let
  wallpaper = import ./wallpaper.nix { inherit config pkgs; };
in
pkgs.writeShellScriptBin "hyprland-exec" ''
  # Wait for awww daemon to be ready before restoring wallpaper
  for i in $(seq 1 20); do
    if ${pkgs.awww}/bin/awww restore 2>/dev/null; then
      break
    fi
    sleep 0.5
  done
  ${wallpaper}/bin/wallpaper || echo "Failed to change wallpaper"
''
