{ pkgs, ... }:
{
  home.packages = with pkgs; [
    swww
  ];

  services.swww.enable = true;

  systemd.user.services.swww = {
    Unit = {
      PartOf = [ "hyprland-session.target" ];
      After = [ "hyprland-session.target" ];
    };
    Install.WantedBy = [ "hyprland-session.target" ];
  };

}
