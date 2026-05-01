{ config, pkgs, ... }:
pkgs.writeShellScriptBin "wallpaper" ''
  WALLPAPER_DIR="${config.home.homeDirectory}/Nextcloud/Wallpapers"
  QUEUE_FILE="/tmp/wallpaper_queue"
  INDEX_FILE="/tmp/wallpaper_index"

  mapfile -t WALLPAPERS < <(${pkgs.coreutils}/bin/ls -1 "$WALLPAPER_DIR"/*)
  TOTAL_WALLPAPERS=''${#WALLPAPERS[@]}

  generate_queue() {
    printf '%s\n' "''${WALLPAPERS[@]}" | ${pkgs.coreutils}/bin/shuf > "$QUEUE_FILE"
    echo "0" > "$INDEX_FILE"
  }

  if [ ! -f "$QUEUE_FILE" ] || [ ! -f "$INDEX_FILE" ]; then
    generate_queue
  fi

  CURRENT_INDEX=$(${pkgs.coreutils}/bin/cat "$INDEX_FILE")

  if [ "$CURRENT_INDEX" -ge "$TOTAL_WALLPAPERS" ]; then
    generate_queue
    CURRENT_INDEX=0
  fi

  mapfile -t QUEUE < "$QUEUE_FILE"
  WALLPAPER="''${QUEUE[$CURRENT_INDEX]}"

  ${pkgs.awww}/bin/awww img "$WALLPAPER" \
    --transition-step 90 \
    --transition-type outer \
    --transition-pos 1.0,0.5

  echo "$((CURRENT_INDEX + 1))" > "$INDEX_FILE"
''
