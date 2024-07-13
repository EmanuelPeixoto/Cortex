{ ... }:
{
  networking.firewall.allowedTCPPorts = [ 80 88 90 443 ]; # 4 NGINX
  networking.firewall.allowedUDPPorts = [ ];
}
