{ pkgs }:
pkgs.writeShellScriptBin "soundboard-setup" ''
  if ! ${pkgs.wireplumber}/bin/wpctl status | grep -qw "sfx.*sink"; then
    ${pkgs.pipewire}/bin/pw-cli create-node adapter '{
      factory.name=support.null-audio-sink
      node.name=sfx
      media.class=Audio/Sink
      object.linger=true
    }'
  fi

  MIC=$(${pkgs.wireplumber}/bin/wpctl inspect @DEFAULT_SOURCE@ | grep "node.name" | cut -d'"' -f2)
  if ! ${pkgs.pipewire}/bin/pw-link -l 2>/dev/null | grep -q "sb-mic"; then
    ${pkgs.pipewire}/bin/pw-loopback -n "sb-mic" -C "$MIC" -P sfx &
    disown
  fi

  echo "Soundboard pronto!"
''
