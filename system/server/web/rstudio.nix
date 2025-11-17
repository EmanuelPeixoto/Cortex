{ config, ... }:
{
  services.nginx.virtualHosts.${config.services.nextcloud.hostName}.locations."^~/rstudio/" = {
    proxyPass = "http://127.0.0.1:8787/";
    proxyWebsockets = true;

    extraConfig = ''
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      access_log /var/log/nginx/rstudio-access.log;
      error_log /var/log/nginx/rstudio-error.log;
    '';
  };
}
