{ pkgs, ... }:
{
  systemd.services.qbittorrent = {
    enable = true;
    description = "qBittorrent-nox service";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --webui-port=8080";
      StateDirectory = "qbittorrent-nox";
      User = "www";
      Group = "nextcloud";
    };
  };
}
