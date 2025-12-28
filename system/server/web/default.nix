{
  imports = [
    ./acme.nix
    ./catch-all.nix
    ./corrida.nix
    ./gabriela.nix
    ./localhost.nix
    ./nextcloud.nix
    ./rstudio.nix
    ./speedtest.nix
    ./torrent.nix
  ];
  services.nginx = {
    enable = true;
    group = "www";

    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    commonHttpConfig = ''
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
  };
}
