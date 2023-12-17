
# Termine instâncias de barras em execução
polybar-msg cmd quit

# Espere até que os processos em execução sejam terminados
while pgrep -u $UID -x .polybar-wrappe >/dev/null; do sleep 1; done

# execute a Polybar, usando a configuração padrão ~/.config/polybar/config.ini
polybar barra &

echo "Polybar lançada..."
