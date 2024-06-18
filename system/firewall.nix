{ ... }:
{  
  networking.firewall.allowedTCPPorts = [ 6600 8888 ]; # MPD NETCAT
  networking.firewall.allowedUDPPorts = [ ];
}
