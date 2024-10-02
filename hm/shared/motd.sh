#!/usr/bin/env bash

# Definir cores
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Funções para obter informações do sistema
get_load() {
  cut -d ' ' -f2 /proc/loadavg
}

get_memory_info() {
  free -m | awk '/Mem/ {printf "%.1f%%|%.1fG", $3/($2+1)*100, $2/1024}'
}

get_swap_info() {
  free -m | awk '/Swap/ {printf "%.1f%%|%.1fG", $3/($2+1)*100, $2/1024}'
}

get_uptime() {
  awk '{printf "%dd-%02dh-%02dm-%02ds", ($1/60/60/24), ($1/60/60%24), ($1/60%60), ($1%60)}' /proc/uptime
}

# Coletar informações
load=$(get_load)
IFS='|' read -r memory_usage memory_total <<< "$(get_memory_info)"
IFS='|' read -r swap_usage swap_total <<< "$(get_swap_info)"
uptime=$(get_uptime)
users=$(users | wc -w)

# Exibir informações
print_header() {
  echo -e "\n${GREEN}======================="
  echo -e "Seja Bem Vindo Emanuel!"
  echo -e "=======================${NC}\n"
}

print_system_info() {
  printf "System load:\t${GREEN}%s${NC}\t\tMemory usage:\t${GREEN}%s${NC} of ${GREEN}%s${NC}\n" "$load" "$memory_usage" "$memory_total"
  printf "Local users:\t${GREEN}%s${NC}\t\tSwap usage:\t${GREEN}%s${NC} of ${GREEN}%s${NC}\n" "$users" "$swap_usage" "$swap_total"
  printf "Uptime:\t\t${GREEN}%s${NC}\n" "$uptime"
  echo -e "To see data traffic type ${GREEN}vnstat${NC}\n"
}

print_disk_usage() {
  echo "Disk Usage:"
  timeout --signal=kill 2s df -h | grep -E "^(/dev/|Sist)"
}

main() {
  print_header
  print_system_info
  print_disk_usage
}

main
