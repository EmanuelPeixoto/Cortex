{ pkgs, ... }:
let
  tplink-ipv6-set = pkgs.buildGoModule {
    pname = "tplink-ipv6-set";
    version = "1.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "EmanuelPeixoto";
      repo = "tplink-ipv6-set";
      rev = "b085858fecdc76e76fcf833e1d9d62e9b8a72bb8";
      hash = "sha256-Dc6tgouw3bYw6x9eCJdEv3H8f8kFnstghIpBLHBOtQw=";
    };
    vendorHash = "sha256-h4U43W3hLoF+p25/jNRaW8okeEzAZQEmKtwB5l4kGW4=";
  };

  updateScript = pkgs.writeShellScriptBin "tplink-ipv6-update" ''
    # Get current prefix and ensure ::cafe exists
    PREFIX=$(${pkgs.iproute2}/bin/ip -6 addr show enp6s0 | ${pkgs.gnugrep}/bin/grep 'scope global.*mngtmpaddr' | ${pkgs.gawk}/bin/awk '{print $2}' | cut -d: -f1-4)
    if [ -z "$PREFIX" ]; then
      echo "No IPv6 prefix found, skipping"
      exit 0
    fi

    CAFE="$PREFIX::cafe"

    # Add ::cafe if missing
    if ! ${pkgs.iproute2}/bin/ip -6 addr show enp6s0 | ${pkgs.gnugrep}/bin/grep -q "$CAFE"; then
      ${pkgs.iproute2}/bin/ip -6 addr add "$CAFE/64" dev enp6s0 2>/dev/null || true
      echo "Added $CAFE"
    fi

    # Always (re)apply the router rules. They are idempotent, so re-applying
    # hourly also recovers from a router reboot that lost the rules without a
    # prefix change (previously it only ran when the prefix changed).
    CACHE="$HOME/.cache/ipv6-prefix"
    ${tplink-ipv6-set}/bin/tplink-ipv6-set -password-file /home/emanuel/.config/senha-wifi.txt "$CAFE"
    echo "$PREFIX" > "$CACHE"
  '';
in
{
  environment.systemPackages = with pkgs; [
    tplink-ipv6-set
    updateScript
    chromium
  ];

  systemd.services.tplink-ipv6-update = {
    description = "Update TP-Link IPv6 firewall rules";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    path = [ pkgs.chromium ];
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      TimeoutStartSec = "120";
      WorkingDirectory = "/home/emanuel/.config";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /home/emanuel/.cache";
      ExecStart = "${updateScript}/bin/tplink-ipv6-update";
      Environment = "HOME=/home/emanuel";
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
