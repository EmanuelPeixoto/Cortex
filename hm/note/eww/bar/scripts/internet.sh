#!/usr/bin/env bash

if nmcli -t -f TYPE,STATE dev | grep -q 'ethernet:connected'; then
  echo " Ethernet"
else
  wifi_info=$(nmcli -t -w 5 -f active,ssid,signal dev wifi | grep sim)

  if [ -n "$wifi_info" ]; then
    ssid=$(echo "$wifi_info" | cut -d':' -f2)
    signal=$(echo "$wifi_info" | cut -d':' -f3)

    case $signal in
      [8][0-9]|9[0-9]|100) icon="󰤨" ;;  # 80-100
      [6][0-9]|7[0-9]) icon="󰤥" ;;     # 60-79
      [4][0-9]|5[0-9]) icon="󰤢" ;;     # 40-59
      [2][0-9]|3[0-9]) icon="󰤟" ;;     # 20-39
      *) icon="󰤯" ;;                    # 0-19
    esac

    echo "$icon $ssid"
  else
    echo "󰤮 Desconectado"
  fi
fi
