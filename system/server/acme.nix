{ config, ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "leunamepeixoto@gmail.com";
    certs.${config.services.nextcloud.hostName} = {
       webroot = null;
      dnsProvider = "duckdns";
      credentialFiles = { "DUCK_DNS_TOKEN_FILE" = "/var/lib/acme/duckdns-token"; };
      group = "www";
    };
  };
}
