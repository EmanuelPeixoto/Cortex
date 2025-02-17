{
  services.nginx = {
    enable = true;
    commonHttpConfig = ''
      charset UTF-8;
      access_log off;
    '';

    virtualHosts."localhost" = {
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
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 ];
}
