{ pkgs, ... }:
{
  boot.initrd.kernelModules = [ "radeon" ];

  services.xserver.videoDrivers = [ "radeon" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };
}
