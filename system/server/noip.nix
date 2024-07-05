{ pkgs, ... }:
{
  systemd.services.noip = {
    enable = true;
    description = "No-ip.com dynamic IP address updater";
    serviceConfig = {
      ExecStart = "${pkgs.noip}/bin/noip2 -c /home/emanuel/.noip";
      StateDirectory = "noip2";
      Type = "forking";
    };
    after = [ "network-online.target"];
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
  };
}
