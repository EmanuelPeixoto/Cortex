{ pkgs, ... }:

pkgs.writeShellScriptBin "hotspot" ''
  set -e

  CONN_NAME="hotspot"
  IFACE="wlp9s0"

  show_usage() {
      echo "Usage:"
      echo "  $0 [SSID] [PASSWORD] [-2] - Activate hotspot (default 5GHz, use -2 for 2.4GHz)"
      echo "  $0 --stop - Deactivate active hotspot"
      echo ""
      echo "Example: $0 MyWifi pass1234"
      exit 1
  }

  stop_hotspot() {
      if ${pkgs.networkmanager}/bin/nmcli -t -f NAME,DEVICE connection show --active | ${pkgs.gnugrep}/bin/grep -q "$CONN_NAME:$IFACE"; then
          echo "[+] Deactivating hotspot..."
          ${pkgs.networkmanager}/bin/nmcli connection down "$CONN_NAME" 2>/dev/null || true

          for uuid in $(${pkgs.networkmanager}/bin/nmcli -t -f NAME,UUID connection show | ${pkgs.gnugrep}/bin/grep "^$CONN_NAME:" | cut -d: -f2); do
              ${pkgs.networkmanager}/bin/nmcli connection delete "$uuid" 2>/dev/null || true
          done
          exit 0
      else
          echo "[-] Hotspot is not active."
          exit 1
      fi
  }

  if [[ "$1" == "--stop" ]]; then
      stop_hotspot
  elif [ $# -lt 2 ] || [ $# -gt 3 ]; then
      show_usage
  fi

  SSID="$1"
  PASSWORD="$2"
  BAND_OPTION="$3"

  if [ ''${#PASSWORD} -lt 8 ]; then
      echo "Error: Password must be at least 8 characters!" >&2
      exit 1
  fi

  if ${pkgs.networkmanager}/bin/nmcli connection show | ${pkgs.gnugrep}/bin/grep -q "$CONN_NAME"; then
      echo "[!] Cleaning old connections named '$CONN_NAME'..."
      ${pkgs.networkmanager}/bin/nmcli connection down "$CONN_NAME" 2>/dev/null || true
      for uuid in $(${pkgs.networkmanager}/bin/nmcli -t -f NAME,UUID connection show | ${pkgs.gnugrep}/bin/grep "^$CONN_NAME:" | cut -d: -f2); do
          ${pkgs.networkmanager}/bin/nmcli connection delete "$uuid" 2>/dev/null || true
      done
  fi

  echo "[+] Creating hotspot '$SSID'..."
  ${pkgs.networkmanager}/bin/nmcli connection add type wifi ifname "$IFACE" con-name "$CONN_NAME" \
    ssid "$SSID" mode ap ipv4.method shared >/dev/null

  if [[ "$BAND_OPTION" == "-2" ]]; then
      echo "[+] Configuring 2.4 GHz band..."
      ${pkgs.networkmanager}/bin/nmcli connection modify "$CONN_NAME" 802-11-wireless.band bg >/dev/null
      ${pkgs.networkmanager}/bin/nmcli connection modify "$CONN_NAME" 802-11-wireless.channel 6 >/dev/null
  else
      echo "[+] Configuring 5 GHz band..."
      ${pkgs.networkmanager}/bin/nmcli connection modify "$CONN_NAME" 802-11-wireless.band a >/dev/null
      ${pkgs.networkmanager}/bin/nmcli connection modify "$CONN_NAME" 802-11-wireless.channel 161 >/dev/null
      ${pkgs.networkmanager}/bin/nmcli connection modify "$CONN_NAME" 802-11-wireless.channel-width 40 >/dev/null
  fi

  echo "[+] Configuring WPA2-PSK security..."
  ${pkgs.networkmanager}/bin/nmcli connection modify "$CONN_NAME" \
    wifi-sec.key-mgmt wpa-psk \
    wifi-sec.psk "$PASSWORD" >/dev/null

  echo "[+] Activating hotspot on interface $IFACE..."
  ${pkgs.networkmanager}/bin/nmcli connection up "$CONN_NAME" ifname "$IFACE" >/dev/null

  echo -e "\n\033[1;32mHotspot activated successfully!\033[0m"
  echo "SSID:      $SSID"
  echo "Password:  $PASSWORD"
  echo "Interface: $IFACE"
  echo "Band:      $([[ "$BAND_OPTION" == "-2" ]] && echo '2.4GHz' || echo '5GHz')"
  echo "To deactivate: $0 --stop"
''
