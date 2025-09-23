{ pkgs, ... }:
{
  security.acme = {
    certs."vitrinescti.duckdns.org" = {
      email = "leunamepeixoto@gmail.com";
      group = "www";
    };
  };

  services.duckdns = {
    enable = true;
    domains = [ "vitrinescti" ];
    tokenFile = "/var/lib/duckdns/token";
  };

  services.nginx = {
    virtualHosts = {
      "Rockaton" = {
        serverName = "vitrinescti.duckdns.org";
        listen = [{
          addr = "0.0.0.0";
          port = 443;
          ssl = true;
        }];

        enableACME = true;
        forceSSL = true;

        root = "/notfound";

        extraConfig = ''
        access_log /var/log/nginx/rockaton-access.log;
        error_log /var/log/nginx/rockaton-error.log;
        autoindex off;
        '';

        locations."/".extraConfig = ''proxy_pass http://127.0.0.1:5173;'';

        locations."/api/" = {
          extraConfig = ''
          proxy_pass http://127.0.0.1:8080/;
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };

      "acme-rockaton" = {
        serverName = "vitrinescti.duckdns.org";
        listen = [{
          addr = "0.0.0.0";
          port = 80;
        }];

        root = "/var/lib/acme/acme-challenge/";

        locations."/".index = "index.html";
      };
    };
  };
}
