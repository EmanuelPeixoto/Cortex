{ config, ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "leunamepeixoto@gmail.com";
    certs.${config.services.nextcloud.hostName} = {
      webroot = null;
      dnsProvider = "duckdns";
      credentialFiles = { "DUCKDNS_TOKEN_FILE" = "/var/lib/acme/duckdns-token"; };
      group = "www";
    };
    certs."torrent.${config.services.nextcloud.hostName}" = {
      group = "www";
    };
    certs."speedtest.${config.services.nextcloud.hostName}" = {
      group = "www";
    };
  };
}
