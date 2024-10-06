{ pkgs, ... }:
{
  services.nextcloud = {
    enable = true;
    https = true;
    hostName = "epeixoto.ddns.net";
    home = "/var/lib/nextcloud";
    package = pkgs.nextcloud30;
    maxUploadSize = "10240M";
    poolSettings = {
      pm = "dynamic";
      "pm.max_children" = "64";
      "pm.max_requests" = "500";
      "pm.max_spare_servers" = "4";
      "pm.min_spare_servers" = "2";
      "pm.start_servers" = "2";
    };
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
