{ config, pkgs, ... }:
let
  steamUser = "emanuel"; # substitua aqui!
in
  {

  services.xserver.enable = true;
  users.users.emanuel.extraGroups = [ "video" "input" ];

  systemd.services.xvfb = {
    description = "Xvfb virtual display";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.xorg.xorgserver}/bin/Xvfb :1 -screen 0 1920x1080x24";
      Restart = "always";
    };
  };

  systemd.services.steam-headless = {
    description = "Steam headless with VirtualGL and Xvfb";
    after = [ "network.target" "xvfb.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = steamUser;
      Environment = "DISPLAY=:1";

      # ExecStart = "${pkgs.virtualgl}/bin/vglrun ${pkgs.steam}/bin/steam -silent";
      ExecStart = "${pkgs.steam}/bin/steam -silent";

      Restart = "always";
      RestartSec = 10;
    };
  };

  environment.systemPackages = with pkgs; [
    virtualgl
    xorg.xvfb
    xterm
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
