{lib, config, pkgs, ...}:
{
  systemd.user.services.swww = {
    Unit = {
      Description = "Sww Daemon";
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.swww}/bin/swww-daemon";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
