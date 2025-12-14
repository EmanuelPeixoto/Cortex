# Define o arquivo do Pipe
PIPE="/tmp/dwm-status-pipe"

# Garante que o Pipe existe e está limpo
rm -f "$PIPE"
mkfifo "$PIPE"

# Paths de hardware
BAT_PATH=$(find /sys/class/power_supply/BAT* -maxdepth 0 2>/dev/null | head -n1)
BACKLIGHT_PATH=$(find /sys/class/backlight/* -maxdepth 0 2>/dev/null | head -n1)

# Cache
cpu_data=""
prev_total=0
prev_idle=0

update_cpu() {
    read -r cpu a b c idle rest < /proc/stat
    total=$((a+b+c+idle))
    diff_idle=$((idle - prev_idle))
    diff_total=$((total - prev_total))
    usage=$((100 * (diff_total - diff_idle) / diff_total))
    prev_total=$total
    prev_idle=$idle
    # Temperatura
    temp=""
    tpath=$(find /sys/class/thermal/thermal_zone*/temp 2>/dev/null | head -n1)
    [ -f "$tpath" ] && temp="$(( $(cat "$tpath") / 1000 ))°C"
    cpu_data="${usage}% $temp"
}

get_infos() {
    # 1. CPU (Atualiza sempre)
    update_cpu

    # 2. RAM
    ram=$(free | awk '/Mem/ {printf "%d%%", $3/$2 * 100}')

    # 3. DISCO
    disk=$(df -h / --output=pcent | sed 1d | tr -d ' \n')

    # 4. WIFI
    if command -v nmcli >/dev/null; then
        wifi_data=$(LC_ALL=C nmcli -t -f ACTIVE,SSID,SIGNAL dev wifi | grep "^yes" | cut -d: -f2,3)
        if [ -n "$wifi_data" ]; then
            ssid=$(echo "$wifi_data" | cut -d: -f1)
            signal=$(echo "$wifi_data" | cut -d: -f2)
            wifi="$ssid ${signal}%"
        else
            wifi="WiFi:off"
        fi
    else
        wifi="NoNMCLI"
    fi

    # 5. BATERIA
    battery=""
    if [ -n "$BAT_PATH" ]; then
        cap=$(cat "$BAT_PATH/capacity")
        status=$(cat "$BAT_PATH/status")
        icon="🔌"
        [ "$status" = "Discharging" ] && icon="🔋"
        battery=" $icon $cap%"
    fi
    
    # 6. BACKLIGHT
    backlight=""
    if [ -n "$BACKLIGHT_PATH" ]; then
        curr=$(cat "$BACKLIGHT_PATH/actual_brightness")
        max=$(cat "$BACKLIGHT_PATH/max_brightness")
        bri="$(( curr * 100 / max ))%"
        backlight="☀$bri"
    fi

    # 7. VOLUME (Wpctl)
    vol_info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    vol_level=$(echo "$vol_info" | awk '{print int($2 * 100)}')
    vol_icon="🔊"
    case "$vol_info" in *"[MUTED]"*) vol_icon="🔇" ;; esac
    volume="$vol_icon$vol_level%"

    # 8. DATA
    time=$(date "+%d/%m %H:%M")
    
    # DESENHA
    xsetroot -name " 💾$disk 🧠$cpu_data 🐸$ram 📡$wifi $backlight$battery $volume 📅$time "
}

while true; do
    get_infos
    
    read -t 2 -n 1 <> "$PIPE"
done
