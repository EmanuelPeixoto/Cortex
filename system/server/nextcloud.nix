{ config, pkgs, ... }:
{
  services.nextcloud = {
    enable = true;
    https = true;
    hostName = "epeixoto.ddns.net";
    package = pkgs.nextcloud31;
    maxUploadSize = "16384M";

    poolSettings = {
      pm = "dynamic";
      "pm.max_children" = "60";
      "pm.start_servers" = "6";
      "pm.min_spare_servers" = "4";
      "pm.max_spare_servers" = "12";
      "pm.max_requests" = "500";
    };

    settings = {
      autoUpdateApps.enable = true;
      autoUpdateApps.startAt = "05:00:00";
      filesystem_check_changes = 1;
      logLevel = 1;
      log_type = "file";
      trusted_domains = [
        "${config.networking.hostName}.local"
        "192.168.0.10"
        "epeixoto.ddns.net"
      ];
      memcache.local = "\\OC\\Memcache\\APCu";
      filelocking.enabled = true;
    };

    config = {
      adminpassFile = "${pkgs.writeText "adminpass" "test123"}";
    };

    phpExtraExtensions = all: [ all.pdlib ];
    phpOptions = {
      "opcache.enable" = "1";
      "opcache.interned_strings_buffer" = "32";
      "opcache.max_accelerated_files" = "20000";
      "opcache.memory_consumption" = "256";
      "opcache.revalidate_freq" = "0";
    };
  };
}
