{ config, lib, pkgs, ... }:
{
  services.nginx = {
    enable = true;
    group = "nginx";

    recommendedOptimisation = true;
    recommendedProxySettings = true;

    commonHttpConfig = ''
      # Logs
      access_log off;
      error_log /var/log/nginx/error.log;

      charset UTF-8;
    '';

    virtualHosts = {
      "${config.networking.hostName}.local" = {
        listen = [{
          addr = "0.0.0.0";
          port = 80;
        }];

        root = "/nginx";

        extraConfig = ''
          autoindex on;
          autoindex_exact_size off;
          autoindex_localtime on;
        '';

        locations = {
          "/" = {
            index = "index.html index.php";
            extraConfig = '' location ~ \.php$ { fastcgi_pass unix:${config.services.phpfpm.pools.nginx.socket}; } '';
          };

          "/favicon.ico".extraConfig = ''access_log off; log_not_found off;'';
        };
      };
    };
  };

  services.phpfpm.pools.nginx = {
    user = "nginx";
    group = "nginx";

    phpPackage = pkgs.php.withExtensions ({ enabled, all }: enabled ++ [ all.pdo_pgsql all.pgsql ]);

    phpEnv.PATH = lib.makeBinPath [ pkgs.php ];

    settings = {
      "listen.owner" = config.services.nginx.user;

      "pm" = "ondemand";
      "pm.max_children" = 5;

      "php_admin_flag[log_errors]" = true;
      "php_admin_value[error_log]" = "stderr";
      "catch_workers_output" = true;
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 ];
}
