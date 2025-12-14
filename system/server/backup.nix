{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "backup-hd" ''
      set -e

      SOURCE="HDs"
      DEST="HD_Backup"
      SHOW_DIFF=true

      if [ "$1" == "--no-diff" ]; then
        SHOW_DIFF=false
      fi

      echo ">>> 1. Importando disco de Backup..."
      zpool import $DEST 2>/dev/null || true

      if ! zpool status $DEST | grep -q "ONLINE"; then
         echo "ERRO: Disco $DEST nao encontrado."
         exit 1
      fi

      echo ">>> 2. Criando Snapshot..."
      TAG="bkp_$(date +%Y-%m-%d_%H-%M)"

      zfs snapshot -r "$SOURCE@$TAG"
      echo "Snapshot criado: $SOURCE@$TAG"

      echo ">>> 3. Verificando envio..."

      LAST_TAG=$(zfs list -t snapshot -o name -s creation -H -r $DEST | grep "bkp_" | tail -n1 | cut -d'@' -f2 || true)

      if [ -z "$LAST_TAG" ]; then
        echo ">>> Primeiro backup (FULL)."
        zfs send -R -v "$SOURCE@$TAG" | zfs recv -F $DEST
      else
        if [ "$SHOW_DIFF" = true ]; then
            echo ">>> ARQUIVOS ALTERADOS DESDE O ULTIMO BACKUP ($LAST_TAG):"
            echo "-----------------------------------------------------"
            for ds in $(zfs list -H -o name -r $SOURCE); do
               if zfs list -t snapshot "$ds@$LAST_TAG" >/dev/null 2>&1; then
                  echo "NA PASTA: $ds"
                  zfs diff -F -H "$ds@$LAST_TAG" "$ds@$TAG" || true
               fi
            done
            echo "-----------------------------------------------------"
        else
            echo ">>> Listagem de arquivos ignorada (--no-diff)."
        fi

        echo ">>> Iniciando envio INCREMENTAL..."
        zfs send -R -v -i "@$LAST_TAG" "$SOURCE@$TAG" | zfs recv -F $DEST
      fi

      echo ">>> 4. Finalizando..."
      zpool export $DEST
      echo ">>> SUCESSO. Pode desconectar."
    '')
  ];
}
