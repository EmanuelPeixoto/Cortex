{ pkgs, ... }:

pkgs.writeShellScriptBin "monitor-mode" ''
  h(){ ${pkgs.hyprland}/bin/hyprctl "$@" 2>/dev/null;}

  m=($(h monitors all|${pkgs.gawk}/bin/awk '/^Monitor/{print $2}'|${pkgs.coreutils}/bin/sort))

  if [[ $(h monitors|${pkgs.gnugrep}/bin/grep -c "^Monitor") -eq 1 ]];then
    echo "ESPELHADO→ESTENDIDO"
    h eval "hl.monitor({output=\"''${m[0]}\",mode=\"preferred\",position=\"0x0\",scale=1,mirror=\"none\"})"
    h eval "hl.monitor({output=\"''${m[1]}\",mode=\"preferred\",position=\"auto-right\",scale=1,mirror=\"none\"})"
  else
    echo "ESTENDIDO→ESPELHADO"
    h eval "hl.monitor({output=\"''${m[0]}\",mode=\"preferred\",position=\"0x0\",scale=1})"
    h eval "hl.monitor({output=\"''${m[1]}\",mode=\"preferred\",position=\"0x0\",scale=1,mirror=\"''${m[0]}\"})"
  fi
''
