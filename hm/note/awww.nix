{ pkgs, ... }:
{
  home.packages = with pkgs; [
    awww
  ];

  services.awww.enable = true;

  systemd.user.services.awww = {
    Unit = {
      PartOf = [ "hyprland-session.target" ];
      After = [ "hyprland-session.target" ];
    };
    Install.WantedBy = [ "hyprland-session.target" ];
  };

}
