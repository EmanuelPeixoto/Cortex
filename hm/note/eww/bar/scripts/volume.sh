#!/usr/bin/env bash

case $1 in
  "up") command="-i" ;;
  "down") command="-d" ;;
esac

if [[ "$command" == "-i" || "$command" == "-d" ]]; then
  pamixer $command 1 --allow-boost --set-limit 125
else
  pamixer --get-volume-human
fi
exit
