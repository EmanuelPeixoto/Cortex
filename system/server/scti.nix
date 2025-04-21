{ pkgs, ... }:
{
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
