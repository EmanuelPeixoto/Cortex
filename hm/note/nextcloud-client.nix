{ pkgs, ... }:
{
  systemd.user.services.nextcloud-client = {
    Unit = {
      Description = "Nextcloud client service";
    };
    Service = {
      ExecStart = "${pkgs.nextcloud-client}/bin/nextcloud --background";
      Restart = "no";
    };
    Install.WantedBy = [ "hyprland-session.target" "gnome-keyring.service" ];
  };
}
