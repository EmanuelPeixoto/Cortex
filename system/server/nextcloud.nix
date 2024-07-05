{ pkgs, ... }:
{
  services.nextcloud = {
    enable = true;
    https = true;
    hostName = "epeixoto.ddns.net";
    home = "/var/lib/nextcloud";
    package = pkgs.nextcloud29;
    maxUploadSize = "10240M";
    settings = {
      log_type = "file";
      logLevel = 1;
      autoUpdateApps.enable = true;
      autoUpdateApps.startAt = "05:00:00";
      filesystem_check_changes = 1;
    };
    config.adminpassFile = "${pkgs.writeText "adminpass" "test123"}";
  };
}
