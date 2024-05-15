#!/usr/bin/env bash

hyprctl dispatch exec '[float] kitty zsh -c "cal -y && echo Aperte Enter para sair... && read"'
