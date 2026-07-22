{ config, pkgs, ... }:
{
  services.qbittorrent = {
    enable = true;
    webuiPort = 8888;
    extraArgs = [
      "--confirm-legal-notice"
      "--save-path=/var/lib/nextcloud/data/root/files/Filmes/"
    ];
  };

  # Allow qbittorrent to write to Nextcloud data directory
  users.users.qbittorrent.extraGroups = [ "nextcloud" ];

  # Create download dir with correct permissions and default ACL
  system.activationScripts.qbittorrent-nextcloud = ''
    mkdir -p /var/lib/nextcloud/data/root/files/Filmes
    chown qbittorrent:nextcloud /var/lib/nextcloud/data/root/files/Filmes
    chmod 2775 /var/lib/nextcloud/data/root/files/Filmes
    ${pkgs.acl}/bin/setfacl -d -m g:nextcloud:rwx /var/lib/nextcloud/data/root/files/Filmes 2>/dev/null || true
  '';
}
