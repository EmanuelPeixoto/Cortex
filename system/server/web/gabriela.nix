{ config, ... }:
{
  services.nginx.virtualHosts.${config.services.nextcloud.hostName}.locations."^~/gabriela" = {
    root = "/var/www/";
    index = "index.html";

    extraConfig = ''
      access_log /var/log/nginx/gabriela-access.log;
      error_log /var/log/nginx/gabriela-error.log;
    '';
  };
}
