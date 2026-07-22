{ config, ... }:
{
  services.nginx.virtualHosts."torrent.${config.services.nextcloud.hostName}" = {
    enableACME = true;
    forceSSL = true;
    listen = [
      { addr = "0.0.0.0"; port = 80; }
      { addr = "[::]"; port = 80; }
      { addr = "0.0.0.0"; port = 443; ssl = true; }
      { addr = "[::]"; port = 443; ssl = true; }
    ];

    locations."/" = {
      proxyPass = "http://127.0.0.1:8888/";
      proxyWebsockets = true;

      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        access_log /var/log/nginx/torrent-access.log;
        error_log /var/log/nginx/torrent-error.log;
      '';
    };
  };
}
