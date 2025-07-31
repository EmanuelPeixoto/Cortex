{ inputs, pkgs, ... }:
{
  hardware.rtl-sdr.enable = true;

  environment.systemPackages = with pkgs; [
    gpredict
    gqrx
    noaa-apt
    sdrpp
    inputs.dsdfme.packages."x86_64-linux".default
  ];

  boot.blacklistedKernelModules = [ "dvb_usb_rtl28xxu" ];

  users.users.emanuel.extraGroups = [ "plugdev" ];
}
