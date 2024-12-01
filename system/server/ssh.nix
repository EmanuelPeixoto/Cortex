{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    age
    sops
  ];

  sops = {
    defaultSopsFile = ./secrets/sshkeys.enc.yaml; # sops -e sshkeys.yaml > sshkeys.enc.yaml
    age.keyFile = "${config.users.users.emanuel.home}/.config/sops/age/keys.txt";
    defaultSopsFormat = "yaml";
    secrets."ssh_authorized_keys" = {
      owner = config.users.users.emanuel.name;
      mode = "0400";
    };
  };

  services.openssh = {
    enable = true;
    ports = [ 44 ];
    settings = {
      X11Forwarding = false;
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  users.users.emanuel.openssh.authorizedKeys.keyFiles = [
    config.sops.secrets."ssh_authorized_keys".path
  ];
}
