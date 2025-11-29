{ config, lib, pkgs, ... }:
let
  poolName = "corrida";
  phpPool = import ./php-pools.nix { inherit config lib pkgs poolName; };
in
{
  imports = [ phpPool ];

  services.nginx.virtualHosts.${config.services.nextcloud.hostName}.locations."^~/${poolName}" = {
    root = "/var/www/";
    index = "index.html index.php";
    extraConfig = ''
      location ~ \.php$ {
        fastcgi_pass unix:${config.services.phpfpm.pools.${poolName}.socket};
      }
      access_log /var/log/nginx/${poolName}-access.log;
      error_log /var/log/nginx/${poolName}-error.log;
    '';
  };
}
