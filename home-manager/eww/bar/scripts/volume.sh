#!/bin/sh

case $1 in
  "up") command="-i" ;;
  "down") command="-d" ;;
esac

if [[ "$command" == "-i" || "$command" == "-d" ]]; then
  pamixer $command 1 --allow-boost --set-limit 125
  exit
else
    pamixer --get-volume-human
    exit
fi
