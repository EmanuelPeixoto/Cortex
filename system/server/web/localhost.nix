{ config, lib, pkgs, ... }:
let
  poolName = "localhost";
  phpPool = import ./php-pools.nix { inherit config lib pkgs poolName; };
in
{
  imports = [ phpPool ];

  services.nginx.virtualHosts."${config.networking.hostName}.local" = {
    serverName = config.networking.hostName+".local";
    listen = [{
      addr = "0.0.0.0";
      port = 80;
    }];

    root = "/var/www/";

    extraConfig = ''
      autoindex on;
      autoindex_exact_size off;
      autoindex_localtime on;
      access_log /var/log/nginx/${poolName}-access.log;
      error_log /var/log/nginx/${poolName}-error.log;
    '';

    locations."/" = {
      index = "index.html index.php";
      extraConfig = ''
        location ~ \.php$ {
          fastcgi_pass unix:${config.services.phpfpm.pools.${poolName}.socket};
        }
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 ];
}
