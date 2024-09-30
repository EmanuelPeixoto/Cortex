#!/usr/bin/env bash

case $1 in
  "up")   wpctl set-volume @DEFAULT_SINK@ 2%+ -l 1.25 ;;
  "down") wpctl set-volume @DEFAULT_SINK@ 2%- -l 1.25 ;;
  *)
    output=$(wpctl get-volume @DEFAULT_SINK@)
    if [[ $output == *"[MUTED]"* ]]; then
      echo "muted"
    else
      awk '{printf "%.0f%%", $2 * 100}' <<< "$output"
    fi
    ;;
esac
