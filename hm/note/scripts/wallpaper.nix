{ config, pkgs, ... }:

pkgs.writeShellScriptBin "wallpaper" ''
  WALLPAPER_DIR="${config.home.homeDirectory}/Cortex/hm/note/assets/wallpapers"
  INDEX_FILE="${config.home.homeDirectory}/Cortex/hm/note/assets/wallpapers/.wallpaper_index"

  # Create an array of all wallpapers
  mapfile -t WALLPAPERS < <(${pkgs.coreutils}/bin/ls -1 "$WALLPAPER_DIR"/*)
  TOTAL_WALLPAPERS=''${#WALLPAPERS[@]}

  # If the index file does not exist, creates with value 0
  if [ ! -f "$INDEX_FILE" ]; then
    echo "0" > "$INDEX_FILE"
  fi

  # Read the current index
  CURRENT_INDEX=$(${pkgs.coreutils}/bin/cat "$INDEX_FILE")

  # Increments the index and returns to the beginning if necessary
  NEXT_INDEX=$(( (CURRENT_INDEX + 1) % TOTAL_WALLPAPERS ))

  # Grab the next wallpaper
  WALLPAPER="''${WALLPAPERS[$NEXT_INDEX]}"

  # Apply wallpaper
  ${pkgs.swww}/bin/swww img "$WALLPAPER" \
    --transition-step 90 \
    --transition-type outer \
    --transition-pos 1.1,0.5

  # Saves the new index
  echo "$NEXT_INDEX" > "$INDEX_FILE"
''
