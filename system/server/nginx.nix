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

          "^~/phpmysql" = {
            root = "/var/www/";
            index = "index.html index.php";
            extraConfig = ''
              location ~ \.php$ {
                include ${pkgs.nginx}/conf/fastcgi.conf;
                fastcgi_pass unix:${config.services.phpfpm.pools.one.socket};
              }
            '';
          };

          "^~/torrent/".extraConfig = ''
            proxy_pass         http://127.0.0.1:8080/;
            proxy_http_version 1.1;

            proxy_set_header   Host               127.0.0.1:8080;
            proxy_set_header   X-Forwarded-Host   $http_host;
            proxy_set_header   X-Forwarded-For    $remote_addr;

            # not used by qBittorrent
            #proxy_set_header   X-Forwarded-Proto  $scheme;
            #proxy_set_header   X-Real-IP          $remote_addr;

            # optionally, you can adjust the POST request size limit, to allow adding a lot of torrents at once
            #client_max_body_size 100M;

            # Since v4.2.2, is possible to configure qBittorrent
            # to set the "Secure" flag for the session cookie automatically.
            # However, that option does nothing unless using qBittorrent's built-in HTTPS functionality.
            # For this use case, where qBittorrent itself is using plain HTTP
            # (and regardless of whether or not the external website uses HTTPS),
            # the flag must be set here, in the proxy configuration itself.
            # Note: If this flag is set while the external website uses only HTTP, this will cause
            # the login mechanism to not work without any apparent errors in console/network resulting in "auth loops".
            proxy_cookie_path  /                  "/; Secure";
          '';
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

        locations = {
          "^~/phpmysql" = {
            root = "/var/www/";
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

          "^~/torrent/".extraConfig = ''
            proxy_pass         http://127.0.0.1:8080/;
            proxy_http_version 1.1;

            proxy_set_header   Host               127.0.0.1:8080;
            proxy_set_header   X-Forwarded-Host   $http_host;
            proxy_set_header   X-Forwarded-For    $remote_addr;

            # not used by qBittorrent
            #proxy_set_header   X-Forwarded-Proto  $scheme;
            #proxy_set_header   X-Real-IP          $remote_addr;

            # optionally, you can adjust the POST request size limit, to allow adding a lot of torrents at once
            #client_max_body_size 100M;

            # Since v4.2.2, is possible to configure qBittorrent
            # to set the "Secure" flag for the session cookie automatically.
            # However, that option does nothing unless using qBittorrent's built-in HTTPS functionality.
            # For this use case, where qBittorrent itself is using plain HTTP
            # (and regardless of whether or not the external website uses HTTPS),
            # the flag must be set here, in the proxy configuration itself.
            # Note: If this flag is set while the external website uses only HTTP, this will cause
            # the login mechanism to not work without any apparent errors in console/network resulting in "auth loops".
            proxy_cookie_path  /                  "/; Secure";
          '';

          "/favicon.ico".extraConfig = ''access_log off; log_not_found off;'';
        };
      };
    };
  };
}
