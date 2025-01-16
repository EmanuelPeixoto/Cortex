{ config, pkgs, ... }:
{
  services.nginx = {
    enable = true;
    group = "www";

    commonHttpConfig = ''
      proxy_max_temp_file_size 0;
      proxy_buffering off;
      server_names_hash_bucket_size 256;
      log_format custom [$time_local] IP: $remote_addr\nSite: $http_referer\nPedido: $request\nAcessado por: $http_user_agent\n;
      access_log /var/log/nginx/access.log custom;
      error_log /var/log/nginx/error.log;
      charset UTF-8;
    '';

    virtualHosts = {
      "${config.networking.hostName}.local" = {
        listen = [{
          addr = "0.0.0.0";
          port = 88;
        }];

        root = "/var/www";

        extraConfig = ''
          access_log off;
          autoindex on;
          autoindex_exact_size off;
          autoindex_localtime on;
          allow all;
        '';

        locations = {
          "/" = {
            index = "index.html index.php";
            extraConfig = ''
              location ~ \.php$ {
                include ${pkgs.nginx}/conf/fastcgi.conf;
                fastcgi_pass unix:${config.services.phpfpm.pools.one.socket};
              }
            '';
          };

          "^~/speedtest" = {
            root = "/var/www/";
            index = "index.html index.php";
            extraConfig = ''
              location ~ \.php$ {
                include ${pkgs.nginx}/conf/fastcgi.conf;
                fastcgi_pass unix:${config.services.phpfpm.pools.one.socket};
              }
            '';
          };
        };
      };

      "http" = {
        listen = [{
          addr = "0.0.0.0";
          port = 80;
        }];

        root = "/var/lib/acme/acme-challenge";
        extraConfig = ''
          autoindex off;
          autoindex_exact_size off;
          autoindex_localtime on;
          allow all;
        '';

        locations."/".index = "index.html index.php";
      };


      ${config.services.nextcloud.hostName} = {
        listen = [{
          addr = "0.0.0.0";
          port = 443;
          # ssl = true;
        }];

        extraConfig = ''
          autoindex off;
          autoindex_exact_size off;
          autoindex_localtime on;
        '';

        # enableACME = true;
        # forceSSL = true;

          "^~/speedtest" = {
            root = "/var/www/";
            index = "index.html index.php";
            extraConfig = ''
              location ~ \.php$ {
                include ${pkgs.nginx}/conf/fastcgi.conf;
                fastcgi_pass unix:${config.services.phpfpm.pools.one.socket};
              }
            '';
          };

          "^~/gabriela" = {
            root = "/var/www/";
            index = "index.html index.php";
            extraConfig = ''
              access_log /var/log/nginx/gabriela.log custom;
              location ~ \.php$ {
                include ${pkgs.nginx}/conf/fastcgi.conf;
                fastcgi_pass unix:${config.services.phpfpm.pools.one.socket};
              }
            '';
          };

          "/favicon.ico".extraConfig = ''access_log off; log_not_found off;'';
        };
      };
    };
  };
}
