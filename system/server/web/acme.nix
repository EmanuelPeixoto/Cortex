{ config, ... }:
{
  services.nginx.virtualHosts."acme" = {
    serverName = config.services.nextcloud.hostName;
    listen = [{
      addr = "0.0.0.0";
      port = 80;
    }];

    root = "/var/lib/acme/acme-challenge/";

    extraConfig = ''
      access_log /var/log/nginx/acme-access.log;
      error_log /var/log/nginx/acme-error.log;
    '';
  };

  networking.firewall.allowedTCPPorts = [ 80 ];
}
