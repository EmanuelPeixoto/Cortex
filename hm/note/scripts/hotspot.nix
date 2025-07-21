{ pkgs, ... }:

pkgs.writeShellScriptBin "hotspot" ''
  set -e

  CONN_NAME="hotspot"
  IFACE="wlp9s0"

  show_usage() {
      echo "Modo de uso:"
      echo "  $0 [SSID] [SENHA] - Ativa hotspot com SSID e senha"
      echo "  $0 --stop - Desativa hotspot ativo"
      echo ""
      echo "Exemplo: $0 MeuWifi senha1234"
      exit 1
  }

  stop_hotspot() {
      if ${pkgs.networkmanager}/bin/nmcli -t -f NAME,DEVICE connection show --active | ${pkgs.gnugrep}/bin/grep -q "$CONN_NAME:$IFACE"; then
          echo "[+] Desativando hotspot..."
          ${pkgs.networkmanager}/bin/nmcli connection down "$CONN_NAME" 2>/dev/null
          ${pkgs.networkmanager}/bin/nmcli connection delete "$CONN_NAME" 2>/dev/null
          exit 0
      else
          echo "[-] Hotspot não está ativo."
          exit 1
      fi
  }

  if [[ "$1" == "--stop" ]]; then
      stop_hotspot
  elif [ $# -ne 2 ]; then
      show_usage
  fi

  SSID="$1"
  PASSWORD="$2"

  if [ ''${#PASSWORD} -lt 8 ]; then
      echo "Erro: Senha deve ter no mínimo 8 caracteres!" >&2
      exit 1
  fi

  if ${pkgs.networkmanager}/bin/nmcli -t -f NAME,DEVICE connection show --active | ${pkgs.gnugrep}/bin/grep -q "$CONN_NAME:$IFACE"; then
      echo "[!] Hotspot já ativo. Desativando antes de criar novo..."
      ${pkgs.networkmanager}/bin/nmcli connection down "$CONN_NAME" 2>/dev/null || true
      ${pkgs.networkmanager}/bin/nmcli connection delete "$CONN_NAME" 2>/dev/null || true
  fi

  echo "[+] Criando hotspot '$SSID'..."
  ${pkgs.networkmanager}/bin/nmcli connection add type wifi ifname "$IFACE" con-name "$CONN_NAME" \
    ssid "$SSID" mode ap ipv4.method shared >/dev/null

  echo "[+] Configurando banda 5 GHz..."
  ${pkgs.networkmanager}/bin/nmcli connection modify "$CONN_NAME" 802-11-wireless.band a >/dev/null
  ${pkgs.networkmanager}/bin/nmcli connection modify "$CONN_NAME" 802-11-wireless.channel 161 >/dev/null
  ${pkgs.networkmanager}/bin/nmcli connection modify "$CONN_NAME" 802-11-wireless.channel-width 40 >/dev/null

  echo "[+] Configurando segurança WPA2-PSK..."
  ${pkgs.networkmanager}/bin/nmcli connection modify "$CONN_NAME" \
    wifi-sec.key-mgmt wpa-psk \
    wifi-sec.psk "$PASSWORD" >/dev/null

  echo "[+] Ativando hotspot..."
  ${pkgs.networkmanager}/bin/nmcli connection up "$CONN_NAME" >/dev/null

  echo -e "\n\033[1;32mHotspot ativado com sucesso!\033[0m"
  echo "SSID:     $SSID"
  echo "Senha:    $PASSWORD"
  echo "Interface: $IFACE"
  echo "Para desativar: $0 --stop"
''
