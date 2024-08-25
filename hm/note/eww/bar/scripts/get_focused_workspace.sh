#!/usr/bin/env bash

get_focused() {
  monitor0=$(hyprctl monitors | grep -A 6 "Monitor eDP-1" | grep active | awk '{print $3}')
  monitor1=$(hyprctl monitors | grep -A 6 "Monitor HDMI-A-1" | grep active | awk '{print $3}')

  # Se não houver workspace ativo, use 0 como valor padrão
  monitor0=${monitor0:-0}
  monitor1=${monitor1:-0}

  echo "[$monitor0, $monitor1]"
}

get_focused

socat -u UNIX-CONNECT:/"$XDG_RUNTIME_DIR"/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
get_focused
done
