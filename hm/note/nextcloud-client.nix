{ lib, ... }:
{
  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  systemd.user.services.nextcloud-client = {
    Service = {
      ExecStop = lib.mkForce [ ];
      TimeoutStopSec = "3s";
    };
    Unit = {
      PartOf = [ "hyprland-session.target" ];
      After = [ "hyprland-session.target" "gnome-keyring.service" ];
    };
    Install.WantedBy = [ "hyprland-session.target" ];
  };
}
