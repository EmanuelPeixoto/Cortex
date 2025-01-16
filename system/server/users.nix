{ pkgs, ... }:
{
  users = {
    users = {
      emanuel = {
        # Set zsh to default shell
        shell = pkgs.zsh;
        isNormalUser = true;
        description = "Emanuel Peixoto";
        extraGroups = [ "networkmanager" "wheel" ];
      };

      # Set www user
      www = {
        # Set zsh to default shell
        shell = pkgs.zsh;
        isSystemUser = true;
        createHome = true;
        home = "/home/www";
        group = "www";
        extraGroups = [ "nextcloud" "wheel" ];
      };
    };

    groups.www = {
      name = "www";
      members = [ "nginx" "nextcloud" "acme" ];
    };
  };
}
