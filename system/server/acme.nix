{
  security.acme = {
    acceptTerms = true;
    defaults.email = "peixoto_emanuel@hotmail.com";
    defaults.webroot = "/var/lib/acme/acme-challenge";
    certs."epeixoto.ddns.net" = {
      email = "peixoto_emanuel@hotmail.com";
      group = "www";
    };
  };
}
