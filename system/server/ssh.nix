{ ... }:
{
  imports = [ ./sshkeys.nix ];

  services.openssh = {
    enable = true;
    ports = [ 44 ];
    settings = {
      X11Forwarding = false;
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };


}
