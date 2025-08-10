{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xorg.xvfb
  ];

  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # Configuração do xrdp
  services.xrdp = {
    enable = true;
    defaultWindowManager = "${pkgs.icewm}/bin/icewm";
  };

  networking.firewall.allowedTCPPorts = [ 3389 ];
}

