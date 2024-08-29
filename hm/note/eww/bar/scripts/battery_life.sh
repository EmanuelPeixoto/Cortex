#!/usr/bin/env bash

SERVICES=("mpd" "mpd-mpris" "nextcloud-client" "swww")

if [ "$(cat /sys/class/power_supply/ADP0/online)" == "1" ]; then
  for SERVICE_NAME in "${SERVICES[@]}"; do
    systemctl --user start ${SERVICE_NAME}
  done
else
  for SERVICE_NAME in "${SERVICES[@]}"; do
    systemctl --user stop ${SERVICE_NAME}
  done
fi
exit 0
