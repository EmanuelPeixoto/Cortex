{ config, pkgs, ...}:
{
  environment.systemPackages = [
    pkgs.glxinfo
  ];

  services.xserver.videoDrivers = [ "nvidia" ];

  boot = {
    extraModprobeConfig = "options nvidia-drm modeset=1";
    initrd.kernelModules = [ "nvidia_modeset" ];
    blacklistedKernelModules = [ "nouveau" ];
  };

  hardware = {
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      modesetting.enable = true;

      open = false;

      nvidiaSettings = true;
    };
    nvidia-container-toolkit.enable = true;
  };
}
