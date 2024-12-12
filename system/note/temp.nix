{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # docker-compose # scti
    # maven # scti poo
    # postman # scti poo
    chromium
  ];

  services.xserver.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # virtualisation.docker.enable = true;

  #joao
  virtualisation.waydroid.enable = true;
}
