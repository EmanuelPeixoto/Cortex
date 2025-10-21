{ pkgs, ... }:

pkgs.writeShellScriptBin "print-selection" ''
  ${pkgs.grimblast}/bin/grimblast save area - | ${pkgs.swappy}/bin/swappy -f -
''
