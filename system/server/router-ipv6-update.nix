{ pkgs, ... }:
let
  tplink-ipv6-set = pkgs.buildGoModule {
    pname = "tplink-ipv6-set";
    version = "1.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "EmanuelPeixoto";
      repo = "tplink-ipv6-set";
      rev = "main";
      hash = "sha256-3iypHTKLWOY+xPNZZ7922NGFAxrVHRGi9wbBqOAFK5A=";
    };
    vendorHash = "sha256-h4U43W3hLoF+p25/jNRaW8okeEzAZQEmKtwB5l4kGW4=";
  };
in
{
  environment.systemPackages = with pkgs; [ tplink-ipv6-set chromium ];

  systemd.services.tplink-ipv6-update = {
    description = "Update TP-Link IPv6 firewall rules";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    path = [ pkgs.chromium pkgs.iproute2 pkgs.gnugrep pkgs.gawk ];
    serviceConfig = {
      Type = "oneshot";
      User = "emanuel";
      TimeoutStartSec = "120";
      WorkingDirectory = "/home/emanuel/.config";
      ExecStart = "${tplink-ipv6-set}/bin/tplink-ipv6-set $(${pkgs.iproute2}/bin/ip -6 addr show enp6s0 | ${pkgs.gnugrep}/bin/grep '::cafe' | ${pkgs.gawk}/bin/awk '{print $2}' | cut -d/ -f1)";
    };
  };

  systemd.timers.tplink-ipv6-update = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "hourly";
      Persistent = true;
    };
  };
}
