{ config, lib, pkgs, ... }:
let
  poolName = "corrida";
  phpPool = import ./php-pools.nix { inherit config lib pkgs poolName; };
in
{
  imports = [ phpPool ];

  services.nginx.virtualHosts."corrida.${config.services.nextcloud.hostName}" = {
    enableACME = true;
    forceSSL = true;
    listen = [
      { addr = "0.0.0.0"; port = 80; }
      { addr = "[::]"; port = 80; }
      { addr = "0.0.0.0"; port = 443; ssl = true; }
      { addr = "[::]"; port = 443; ssl = true; }
    ];

    locations."/" = {
      root = "/var/www/corrida/";
      extraConfig = ''
        index index.html index.php;

        location ~ \.php$ {
          fastcgi_pass unix:${config.services.phpfpm.pools.${poolName}.socket};
        }
      '';
    };

    extraConfig = ''
      access_log /var/log/nginx/${poolName}-access.log;
      error_log /var/log/nginx/${poolName}-error.log;
    '';
  };
}
