{ config, ... }:
{
  services.nginx = {
    enable = true;
    group = "www";

    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    commonHttpConfig = ''
      # Segurança
      add_header X-Content-Type-Options "nosniff" always;
      add_header X-Frame-Options "SAMEORIGIN" always;
      add_header X-XSS-Protection "1; mode=block" always;
      add_header Referrer-Policy "strict-origin-when-cross-origin" always;

      # Performance
      aio threads;
      keepalive_requests 1000;

      # Limites
      client_body_buffer_size 128k;
      client_header_buffer_size 4k;
      large_client_header_buffers 4 16k;

      # Logs
      access_log /var/log/nginx/access.log;
      error_log /var/log/nginx/error.log;

      charset UTF-8;
    '';

    virtualHosts = {
      "${config.networking.hostName}.local" = {
        listen = [{
          addr = "0.0.0.0";
          port = 88;
        }];

        root = "/var/www/";

        extraConfig = ''
          autoindex on;
          autoindex_exact_size off;
          autoindex_localtime on;
        '';

        locations = {
          "/" = {
            index = "index.html index.php";
            extraConfig = '' location ~ \.php$ { fastcgi_pass unix:${config.services.phpfpm.pools.one.socket}; } '';
          };

          "^~/speedtest" = {
            root = "/var/www/";
            index = "index.html index.php";
            extraConfig = '' location ~ \.php$ { fastcgi_pass unix:${config.services.phpfpm.pools.one.socket}; } '';
          };
        };
      };

      "http" = {
        listen = [{
          addr = "0.0.0.0";
          port = 80;
        }];

        root = "/var/lib/acme/acme-challenge/";

        locations."/".index = "index.html";
      };


      ${config.services.nextcloud.hostName} = {
        listen = [{
          addr = "0.0.0.0";
          port = 443;
          ssl = true;
        }];

        enableACME = true;
        forceSSL = true;

        locations = {
          "^~/speedtest" = {
            root = "/var/www/";
            index = "index.html index.php";
            extraConfig = '' location ~ \.php$ { fastcgi_pass unix:${config.services.phpfpm.pools.one.socket}; } '';
          };

          "^~/gabriela" = {
            root = "/var/www/";
            index = "index.html index.php";
            extraConfig = ''
              location ~ \.php$ { fastcgi_pass unix:${config.services.phpfpm.pools.one.socket}; }
            '';
          };

          "/grafana/" = {
            proxyPass = "http://127.0.0.1:3000/";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_set_header Host $http_host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              
              # Desabilita cache do navegador
              add_header Cache-Control "no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0";
              expires off;
              
              # Preservar trailing slash ao fazer proxy
              proxy_redirect /login /grafana/login;
              proxy_redirect / /grafana/;
            '';
          };

          "/favicon.ico".extraConfig = ''access_log off; log_not_found off;'';
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 88 443 ];
}
