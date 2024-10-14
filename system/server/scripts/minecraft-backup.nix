{ pkgs, ... }:
pkgs.writeShellScriptBin "minecraft-backup" ''
  MINECRAFT_DIR="/var/lib/minecraft"
  REPO_DIR="/var/lib/minecraft/.git"
  SSH_DIR="/var/lib/minecraft/.ssh"

  export PATH="${pkgs.git}/bin:${pkgs.openssh}/bin:$PATH"

  git config --global user.email "peixoto_emanuel@hotmail.com"
  git config --global user.name "EmanuelPeixoto"

  if [ ! -d $SSH_DIR ]; then
    ssh-keygen -t rsa -b 4096 -C "NixOS-Server-Minecraft" -N "" -f $SSH_DIR/id_rsa
  fi

  if [ ! -d "$REPO_DIR" ]; then
    cd "$MINECRAFT_DIR"
    git init
    git remote add origin git@github.com:EmanuelPeixoto/MC-Server.git
  fi

  cd "$MINECRAFT_DIR"
  git add .
  git commit -m "Backup automático - $(date '+%Y-%m-%d %H:%M:%S')"

  # Use GIT_SSH_COMMAND to specify the SSH key
  export GIT_SSH_COMMAND="ssh -i $SSH_DIR/id_rsa -o StrictHostKeyChecking=no"
  git push origin main
''
