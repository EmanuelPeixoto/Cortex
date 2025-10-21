{ pkgs, ... }:

pkgs.writeShellScriptBin "print" ''
  ${pkgs.grimblast}/bin/grimblast save screen - | ${pkgs.swappy}/bin/swappy -f -
''
