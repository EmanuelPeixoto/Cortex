{ pkgs, ... }:

let
  tokenFile = "/var/lib/acme/duckdns-token";
  domainFile = "/var/lib/acme/duckdns-domain";
in
{
  systemd.services.duckdns = {
    description = "DuckDNS IPv6-only Update";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    startAt = "*:0/5";

    script = ''
      IPV6=$(${pkgs.iproute2}/bin/ip -6 addr show enp6s0 | ${pkgs.gnugrep}/bin/grep "scope global" | head -n1 | ${pkgs.gawk}/bin/awk '{print $2}' | cut -d/ -f1)
      TOKEN=$(cat ${tokenFile})
      DOMAIN=$(cat ${domainFile})
      if [ -n "$IPV6" ] && [ -n "$DOMAIN" ]; then
      ${pkgs.curl}/bin/curl -s "https://www.duckdns.org/update?domains=$DOMAIN&token=$TOKEN&ip=&ipv6=$IPV6"
      else
      echo "Erro: IPv6 ou arquivos de configuração não encontrados"
      exit 1
      fi
      '';

    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
