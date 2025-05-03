{ inputs, pkgs, ... }:
{
  hardware.rtl-sdr.enable = true;

  environment.systemPackages = with pkgs; [
    cubicsdr
    gnuradio
    gpredict
    gqrx
    noaa-apt
    qemu
    sdrpp
    sox
    inputs.dsdfme.packages."x86_64-linux".default
  ];

  programs.java = {
    enable = true;
    package = pkgs.openjdk23.override { enableJavaFX = true; };
  };

  boot.blacklistedKernelModules = [ "dvb_usb_rtl28xxu" ];

  users.users.emanuel.extraGroups = [ "plugdev" ];
}
