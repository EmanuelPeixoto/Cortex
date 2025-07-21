{
  networking.nat = {
    enable = true;
    internalInterfaces = [ "wlp9s0" ];
    externalInterface = "enp8s0";
  };

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "wlp9s0" ];
    allowedTCPPorts = [ 53 ]; # DNS
    allowedUDPPorts = [ 53 67 68 ]; # DNS + DHCP
  };
}
