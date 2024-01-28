{lib, config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    openssl_legacy
  ];
  services.nginx = {
    package = pkgs.nginxStable.override { openssl = pkgs.libressl; };
    enable = true;
    group = "users";
    commonHttpConfig = ''
      proxy_max_temp_file_size 0;
      proxy_buffering off;
      server_names_hash_bucket_size 256;
      charset UTF-8;
    '';


    virtualHosts."https" = {
      listen = [{
        addr = "0.0.0.0";
        port = 443;
        ssl = true;
      }];

      root = "/nginxaaa";
      extraConfig = "autoindex on; \n autoindex_exact_size off; \n autoindex_localtime on; allow all; \n ssl_certificate /nginxaaa/nginx.crt; \n ssl_certificate_key /nginxaaa/nginx.key;";

      locations."/" = {
        index = "index.html index.php";
      };
    };
  };
}
