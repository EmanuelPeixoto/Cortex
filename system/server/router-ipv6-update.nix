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

    # Check if prefix changed
    CACHE="$HOME/.cache/ipv6-prefix"
    if [ -f "$CACHE" ] && [ "$(cat $CACHE)" = "$PREFIX" ]; then
      exit 0
    fi

    ${tplink-ipv6-set}/bin/tplink-ipv6-set "$CAFE"
    echo "$PREFIX" > "$CACHE"
  '';
in
{
  environment.systemPackages = with pkgs; [ tplink-ipv6-set updateScript chromium ];

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
