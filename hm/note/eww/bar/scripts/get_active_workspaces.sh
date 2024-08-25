#!/usr/bin/env bash

get_active() {
  workspace_ids_0=()
  workspace_ids_1=()
  while IFS= read -r line; do
    if [[ $line == workspace* ]]; then
      id=$(echo "$line" | awk '{print $3}')
      monitor=$(echo "$line" | awk -F 'monitor ' '{print $2}' | awk '{print $1}')
      if [[ $monitor == "eDP-1:" ]]; then
        workspace_ids_0+=("$id")
      elif [[ $monitor == "HDMI-A-1:" ]]; then
        workspace_ids_1+=("$id")
      fi
    fi
  done < <(hyprctl workspaces)

  # Sort the arrays
  IFS=$'\n' sorted_workspace_ids_0=($(sort -n <<< "${workspace_ids_0[*]}"))
  IFS=$'\n' sorted_workspace_ids_1=($(sort -n <<< "${workspace_ids_1[*]}"))

  echo -n "["
  # Array for monitor 0 (eDP-1)
  echo -n "["
  for ((i = 0; i < ${#sorted_workspace_ids_0[@]}; i++)); do
    echo -n "${sorted_workspace_ids_0[i]}"
    if ((i != ${#sorted_workspace_ids_0[@]} - 1)); then
      echo -n ", "
    fi
  done
  echo -n "],"
  # Array for monitor 1 (HDMI-A-1)
  echo -n "["
  for ((i = 0; i < ${#sorted_workspace_ids_1[@]}; i++)); do
    echo -n "${sorted_workspace_ids_1[i]}"
    if ((i != ${#sorted_workspace_ids_1[@]} - 1)); then
      echo -n ", "
    fi
  done
  echo -n "]"
  echo "]"
}

print_workspaces() {
  echo "$(get_active)"
}

print_workspaces

socat -u UNIX-CONNECT:"$XDG_RUNTIME_DIR"/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock - | while read -r event; do
print_workspaces
done
