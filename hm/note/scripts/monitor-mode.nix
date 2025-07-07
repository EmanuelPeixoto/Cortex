{ pkgs, ... }:
pkgs.writeShellScriptBin "monitor-mode" ''
  h(){ ${pkgs.hyprland}/bin/hyprctl "$@" 2>/dev/null;}

  m=($(h monitors all|${pkgs.gawk}/bin/awk '/^Monitor/{print $2}'|${pkgs.coreutils}/bin/sort))
  r=($(for i in ''${m[@]};do h monitors all|${pkgs.gnugrep}/bin/grep -A10 "Monitor $i"|${pkgs.gnugrep}/bin/grep -oP '[0-9]+x[0-9]+@[0-9.]+';done))

  if [[ $(h monitors|${pkgs.gnugrep}/bin/grep -c "^Monitor") -eq 1 ]];then
    echo "ESPELHADO→ESTENDIDO"
    h keyword monitor "''${m[0]},''${r[0]},0x0,1"
    h keyword monitor "''${m[1]},''${r[1]},''${r[0]%x*}x0,1"
  else
    echo "ESTENDIDO→ESPELHADO"
    h keyword monitor "''${m[0]},''${r[0]},0x0,1"
    h keyword monitor "''${m[1]},''${r[1]},0x0,1,mirror,''${m[0]}"
  fi
''
