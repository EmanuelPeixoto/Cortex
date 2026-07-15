{ pkgs }:
pkgs.writeShellScriptBin "soundboard" ''
  SOUND="$1"
  if [ -z "$SOUND" ]; then
    echo "Uso: soundboard <arquivo.wav|mp3|ogg>"
    exit 1
  fi

  ${pkgs.procps}/bin/pkill -9 -f "pw-play.*$(${pkgs.coreutils}/bin/basename "$SOUND")" 2>/dev/null
  ${pkgs.pipewire}/bin/pw-play --target=sfx "$SOUND" &
  ${pkgs.pipewire}/bin/pw-play --volume=0.5 "$SOUND" &
''
