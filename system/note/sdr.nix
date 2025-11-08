{ inputs, pkgs, ... }:
{
  hardware.rtl-sdr.enable = true;

  environment.systemPackages = with pkgs; [
    gpredict
    noaa-apt
    sdrpp
  ];

  boot.blacklistedKernelModules = [ "dvb_usb_rtl28xxu" ];

  users.users.emanuel.extraGroups = [ "plugdev" ];
}
