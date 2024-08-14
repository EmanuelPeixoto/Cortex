{ pkgs, ... }:
{
  systemd.user.services.swww = {
    Unit = {
      Description = "Sww Daemon";
    };
    Service = {
      ExecStart = "${pkgs.swww}/bin/swww-daemon -q -f xrgb";
      Restart = "no";
    };
    Install.WantedBy = ["hyprland-session.target"];
  };
}
