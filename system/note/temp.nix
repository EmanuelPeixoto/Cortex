{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    chromium
  ];

  # services.xserver.enable = true;
  # services.xserver.desktopManager.xfce.enable = true;

  #joao
  virtualisation.waydroid.enable = true;

  networking.extraHosts = ''
    192.168.0.10   epeixoto.ddns.net
  '';

    services.nginx = {
    enable = true;
    commonHttpConfig = ''
      charset UTF-8;
    '';

    virtualHosts."localhost" = {
      listen = [{
        addr = "0.0.0.0";
        port = 80;
      }];

      root = "/Filmes";
      extraConfig = "autoindex on; \n autoindex_exact_size off; \n autoindex_localtime on; allow all;";
      locations."/" = { index = "index.html index.php"; };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 ];
}
