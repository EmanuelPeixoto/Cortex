{ pkgs, ... }:

pkgs.writeShellScriptBin "print" ''
  ${pkgs.grim}/bin/grim -l 0 - | ${pkgs.swappy}/bin/swappy -f -
''
