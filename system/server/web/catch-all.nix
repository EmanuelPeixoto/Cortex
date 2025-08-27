{ pkgs, ... }:
let
  snakeoil = pkgs.runCommand "snakeoil-cert" { buildInputs = [ pkgs.openssl ]; } ''
    mkdir -p $out
    ${pkgs.openssl}/bin/openssl req -x509 -nodes -days 365 \
      -newkey rsa:2048 \
      -keyout $out/key.pem \
      -out $out/cert.pem \
      -subj "/CN=catch-all"
  '';
in
{
  environment.etc."ssl/certs/ssl-cert-snakeoil.pem".source = "${snakeoil}/cert.pem";
  environment.etc."ssl/private/ssl-cert-snakeoil.key".source = "${snakeoil}/key.pem";

  services.nginx.virtualHosts = {
    "catchall-https" = {
      serverName = "_";
      listen = [{
        addr = "0.0.0.0";
        port = 443;
        ssl = true;
        extraParameters = [ "default_server" ];
      }];

      extraConfig = ''
        ssl_certificate /etc/ssl/certs/ssl-cert-snakeoil.pem;
        ssl_certificate_key /etc/ssl/private/ssl-cert-snakeoil.key;
        access_log /var/log/nginx/gabriela-access.log;
        error_log /var/log/nginx/gabriela-error.log;
        return 444;
      '';
    };

    "catchall-http" = {
      serverName = "_";
      listen = [{
        addr = "0.0.0.0";
        port = 80;
        extraParameters = [ "default_server" ];
      }];

      extraConfig = ''
        access_log /var/log/nginx/catchall-access.log;
        error_log /var/log/nginx/catchall-error.log;
        return 444;
      '';
    };
  };
}
