{
  services.openssh = {
    enable = true;
    ports = [ 44 ];
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
}
