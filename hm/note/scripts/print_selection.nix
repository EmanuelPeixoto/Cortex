{ pkgs, ... }:

pkgs.writeShellScriptBin "print_selection" ''
  ${pkgs.grim}/bin/grim -l 0 -g "$(${pkgs.slurp}/bin/slurp -d -w 0)" - | ${pkgs.swappy}/bin/swappy -f -
''
