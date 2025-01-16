{ pkgs, ... }:
{
  home.packages = with pkgs; [
    swww
  ];

  systemd.user.services.swww = {
    Unit = {
      Description = "Sww Daemon";
      PartOf = [ "hyprland-session.target" ];
      After = [ "hyprland-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.swww}/bin/swww-daemon -q -f xrgb";
      Restart = "no";
    };
    Install.WantedBy = ["hyprland-session.target"];
  };
}
