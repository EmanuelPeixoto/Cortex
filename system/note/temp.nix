{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    jetbrains.idea-ultimate # scti poo
    # docker-compose # scti
    # maven # scti poo
    jdk17 # scti poo
    # postman # scti poo
    chromium
  ];

  # virtualisation.docker.enable = true;

  #joao
  virtualisation.waydroid.enable = true;
}
