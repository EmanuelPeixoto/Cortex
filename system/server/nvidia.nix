{ config, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.mesa-demos
  ];

  services.xserver.videoDrivers = [ "nvidia" ];

  boot = {
    extraModprobeConfig = "options nvidia-drm modeset=1";
    blacklistedKernelModules = [ "nouveau" ];
  };

  hardware = {
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.legacy_580;

      modesetting.enable = true;

      open = false;

      nvidiaSettings = true;
    };
  };
}
