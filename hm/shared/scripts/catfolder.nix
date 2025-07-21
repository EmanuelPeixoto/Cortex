{ pkgs, ... }:

pkgs.writeShellScriptBin "catfolder" ''
  ${pkgs.findutils}/bin/find . -type f -exec echo "=== {} ===" \; -exec ${pkgs.coreutils}/bin/cat {} \;
''
