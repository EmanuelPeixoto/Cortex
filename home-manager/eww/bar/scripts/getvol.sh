#!/bin/sh

if [ $(pamixer --get-mute) == true ]; then
  echo muted
  exit
else
  pamixer --get-volume
fi
