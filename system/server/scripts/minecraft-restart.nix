{ config, pkgs, ... }:
let
rcon-cli = pkgs.writeShellScriptBin "rcon-cli" ''
  ${pkgs.mcrcon}/bin/mcrcon -H 127.0.0.1 -P 25575 -p "${config.services.minecraft-server.serverProperties."rcon.password"}" "$@"
'';
in
pkgs.writeShellScriptBin "minecraft-restart" ''
  function send_message() {
    ${rcon-cli}/bin/rcon-cli 'tellraw @a {"text":"[SERVIDOR] '"$1"'","color":"green"}'
  }

  send_message "O servidor será reiniciado em 30 minutos."
  sleep 1200

  send_message "O servidor será reiniciado em 10 minutos."
  sleep 540

  for i in {10..1}
  do
  send_message "O servidor será reiniciado em $i segundos."
  sleep 1
  done

  send_message "Reiniciando o servidor agora!"
  ${pkgs.systemd}/bin/systemctl restart minecraft-server.service
''
