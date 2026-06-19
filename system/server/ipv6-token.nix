{ pkgs, ... }:
{
  # Disable privacy extensions
  boot.kernel.sysctl."net.ipv6.conf.enp6s0.use_tempaddr" = 0;

  # After network is up, add stable ::cafe address and flush temp addresses
  systemd.services.ipv6-cafe = {
    description = "Add stable IPv6 ::cafe address";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      # Get current IPv6 prefix from SLAAC
      PREFIX=$(${pkgs.iproute2}/bin/ip -6 addr show enp6s0 | ${pkgs.gnugrep}/bin/grep "scope global.*mngtmpaddr" | ${pkgs.gawk}/bin/awk '{print $2}' | cut -d: -f1-4)
      if [ -n "$PREFIX" ]; then
        # Add stable ::cafe address
        ${pkgs.iproute2}/bin/ip -6 addr add ''${PREFIX}::cafe/64 dev enp6s0 2>/dev/null || true
      fi
    '';
  };
}
