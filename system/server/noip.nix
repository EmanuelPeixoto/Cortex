{ pkgs, ... }:
{
  systemd.services.noip = {
    enable = false; # my router is doing this
    description = "No-ip.com dynamic IP address updater";
    after = [ "network-online.target"];
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.noip}/bin/noip2 -c /home/emanuel/.noip";
      StateDirectory = "noip2";
      Type = "forking";
    };
  };
}
