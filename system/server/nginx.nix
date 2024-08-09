{ config, pkgs, ... }:
{
  services.nginx = {
    additionalModules = with pkgs.nginxModules; [ geoip2 ];
    package = pkgs.nginxStable.override { openssl = pkgs.libressl; };
    enable = true;
    group = "www";

    commonHttpConfig = ''
      proxy_max_temp_file_size 0;
      proxy_buffering off;
      server_names_hash_bucket_size 256;
      log_format custom [$time_local] IP: $remote_addr | País: $geoip2_data_country_name | UF: geoip_region | Cidade: $geoip2_data_city_name \nSite: $http_referer \nPedido: $request \nAcessado por: $http_user_agent \n;
      log_format fotos [$time_local] IP: $remote_addr | País: $geoip2_data_country_name | UF: geoip_region | Cidade: $geoip2_data_city_name | Acessado por: $http_user_agent;
      access_log /var/log/nginx/access.log custom;
      error_log /var/log/nginx/error.log;
      charset UTF-8;
    '';

    virtualHosts."localhost" = {
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

      locations."/" = {
        index = "index.html index.php";
        extraConfig = ''
          location ~ \.php$ {
            include ${pkgs.nginx}/conf/fastcgi.conf;
            fastcgi_pass unix:${config.services.phpfpm.pools.one.socket};
          }
        '';
      };

      locations."^~/speedtest" = {
        root = "/var/www/";
        index = "index.html index.php";
        extraConfig = ''
          location ~ \.php$ {
            include ${pkgs.nginx}/conf/fastcgi.conf;
            fastcgi_pass unix:${config.services.phpfpm.pools.one.socket};
          }
        '';
      };

      locations."^~/phpmysql" = {
        root = "/var/www/";
        index = "index.html index.php";
        extraConfig = ''
          location ~ \.php$ {
            include ${pkgs.nginx}/conf/fastcgi.conf;
            fastcgi_pass unix:${config.services.phpfpm.pools.one.socket};
          }
        '';
      };

      locations."^~/torrent/".extraConfig = ''include /var/www/.proxytorrent;'';
    };

    virtualHosts."http" = {
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


    virtualHosts.${config.services.nextcloud.hostName} = {
      listen = [{
        addr = "0.0.0.0";
        port = 443;
        ssl = true;
      }];

      extraConfig = ''
        autoindex off;
        autoindex_exact_size off;
        autoindex_localtime on;
      '';

      enableACME = true;
      forceSSL = true;

      locations."^~/phpmysql" = {
        root = "/var/www/";
        index = "index.html index.php";
        extraConfig = ''
          location ~ \.php$ {
            include ${pkgs.nginx}/conf/fastcgi.conf;
            fastcgi_pass unix:${config.services.phpfpm.pools.one.socket};
          }
        '';
      };

      locations."^~/torrent/".extraConfig = ''include /var/www/.proxytorrent;'';

      locations."/favicon.ico".extraConfig = ''access_log off; log_not_found off;'';

      locations."^~/speedtest" = {
        root = "/var/www/";
        index = "index.html index.php";
        extraConfig = ''
          location ~ \.php$ {
            include ${pkgs.nginx}/conf/fastcgi.conf;
            fastcgi_pass unix:${config.services.phpfpm.pools.one.socket};
          }
        '';
      };

      locations."^~/gabriela" = {
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
    };

    virtualHosts."SCTI" = {
      listen = [{
        addr = "0.0.0.0";
        port = 90;
      }];

      root = "/notfound";

      extraConfig = ''
        access_log off;
        autoindex off;
        autoindex_exact_size off;
        autoindex_localtime on;
        allow all;
      '';

      locations."/".extraConfig = ''proxy_pass http://127.0.0.1:8081;'';
    };

    appendHttpConfig = ''
      geoip2 /var/www/.geoip/GeoLite2-Country.mmdb {
        auto_reload 5m;
        $geoip2_metadata_country_build metadata build_epoch;
        $geoip2_data_country_code country iso_code;
        $geoip2_data_country_name country names en;
        $geoip2_data_continent_code continent code;
        $geoip2_data_continent_name continent names en;
      }

      geoip2 /var/www/.geoip/GeoLite2-City.mmdb {
        auto_reload 5m;
        $geoip2_data_city_name city names en;
        $geoip2_data_lat location latitude;
        $geoip2_data_lon location longitude;
      }

      geoip2 /var/www/.geoip/GeoLite2-ASN.mmdb {
        auto_reload 5m;
        $geoip2_data_asn autonomous_system_number;
        $geoip2_data_asorg autonomous_system_organization;
      }

      fastcgi_param MM_CONTINENT_CODE $geoip2_data_continent_code;
      fastcgi_param MM_CONTINENT_NAME $geoip2_data_continent_name;
      fastcgi_param MM_COUNTRY_CODE $geoip2_data_country_code;
      fastcgi_param MM_COUNTRY_NAME $geoip2_data_country_name;
      fastcgi_param MM_CITY_NAME    $geoip2_data_city_name;
      fastcgi_param MM_LATITUDE $geoip2_data_lat;
      fastcgi_param MM_LONGITUDE $geoip2_data_lon;
      fastcgi_param MM_ISP $geoip2_data_asorg;
    '';
  };
}
