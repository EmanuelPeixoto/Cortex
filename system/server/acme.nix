{
  security.acme = {
    acceptTerms = true;
    defaults.email = "leunamepeixoto@gmail.com";
    defaults.webroot = "/var/lib/acme/acme-challenge";
    certs."epeixoto.ddns.net" = {
      email = "leunamepeixoto@gmail.com";
      group = "www";
    };
  };
}
