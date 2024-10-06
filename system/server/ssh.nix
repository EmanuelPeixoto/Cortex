{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    age
    sops
  ];

  sops = {
    defaultSopsFile = ./secrets/ssh_keys.enc.yaml;
    age.keyFile = "${config.users.users.emanuel.home}/.config/sops/age/keys.txt";
    defaultSopsFormat = "yaml";
    secrets.ssh_authorized_keys = {
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

  # Only use the secret file if it exists
  users.users.emanuel.openssh.authorizedKeys = {
    keyFiles = lib.optional
    (builtins.pathExists config.sops.secrets.ssh_authorized_keys.path)
    config.sops.secrets.ssh_authorized_keys.path;
  };
}
