{ config, ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "leunamepeixoto@gmail.com";
    certs.${config.services.nextcloud.hostName} = {
       webroot = null;
      dnsProvider = "duckdns";
      credentialsFile = "/var/lib/acme/duckdns-token";
      group = "www";
    };
  };
}
