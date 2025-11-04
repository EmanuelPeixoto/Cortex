{ config, pkgs, ...}:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
export __NV_PRIME_RENDER_OFFLOAD=1
export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-GO
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __VK_LAYER_NV_optimus=NVIDIA_only
exec "$@"
'';
in {
  environment.systemPackages = [
    nvidia-offload
    pkgs.mesa-demos
  ];

  services.xserver.videoDrivers = [ "nvidia" ];

  boot = {
    extraModprobeConfig = "options nvidia-drm modeset=1";
    initrd.kernelModules = [ "nvidia_modeset" ];
    blacklistedKernelModules = [ "nouveau" ];
  };

  systemd.services.systemd-udev-trigger.restartIfChanged = false;

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidiaOptimus.disable = false;

    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      modesetting.enable = true;

      powerManagement = {
        enable = true;
        finegrained = true;
      };

      open = false;

      nvidiaSettings = true;

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        sync.enable = false;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    nvidia-container-toolkit.enable = true;
  };
}
