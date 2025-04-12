{ inputs, pkgs, ... }:
{
  hardware.rtl-sdr.enable = true;

  environment.systemPackages = with pkgs; [
    sox
    gnuradio
    gqrx
    cubicsdr
    gpredict # opcional, para rastreamento de satélites
    noaa-apt # para NOAA
  ];

  users.users.emanuel.extraGroups = [ "plugdev" ];

  inputs.dsdfme.packages."x86_64-linux".default
}
