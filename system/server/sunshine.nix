{ pkgs, ... }:
{
  services.sunshine = {
    enable = true;
    package = pkgs.stable.sunshine.override { cudaSupport = true; };
    openFirewall = true;
  };

  # Isso ainda é uma boa prática
  services.udev.packages = [
    pkgs.sunshine
  ];

  # boot.kernelParams = [ "video=DP-8:1920x1080R@60D" ];

  # 1. Adicione "uinput" aqui
  # users.users."emanuel".extraGroups = [ "input" "video" "render" "uinput" ];

  environment.systemPackages = [
    pkgs.sunshine
    pkgs.wine
  ];

  services.displayManager = {
    autoLogin = {
      enable = true;
      user = "emanuel";
    };
    defaultSession = "none+icewm";
  };


  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    windowManager.icewm.enable = true;
    displayManager.lightdm.enable = true;
  };
}
