{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # docker-compose # scti
    # maven # scti poo
    # postman # scti poo
    chromium
  ];

  # virtualisation.docker.enable = true;

  #joao
  virtualisation.waydroid.enable = true;
}
