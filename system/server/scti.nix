{ pkgs, ... }:
{
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      #type database DBuser auth-method
      local all      all    trust
      #type database DBuser Address      auth-method
      host  all      all    127.0.0.1/32 trust
      host  all      all    ::1/128      trust
    '';
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  virtualisation.docker.enable = true;

  users.users.emanuel.extraGroups = [ "docker" ];

  users = {
    users = {
      scti = {
        # Set zsh to default shell
        shell = pkgs.zsh;
        isNormalUser = true;
        description = "SCTI";
        extraGroups = [ "docker" ];
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8080 ];
}
