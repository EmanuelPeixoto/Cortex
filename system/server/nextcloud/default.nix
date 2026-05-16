{ config, pkgs, ... }:
let
  cfg = import ./domain.nix;
in
{
  imports = [
    ./database.nix
    ./facerecognition.nix
    ./php.nix
  ];

  services.nextcloud = {
    enable = true;
    https = true;
    hostName = cfg.nextcloudDomain;
    package = pkgs.nextcloud33;
    maxUploadSize = "16384M";

    settings = {
      autoUpdateApps.enable = true;
      autoUpdateApps.startAt = "05:00:00";
      filesystem_check_changes = 1;
      logLevel = 1;
      log_type = "file";
      trusted_domains = [
        "${config.services.nextcloud.hostName}"
        "${config.networking.hostName}.local"
        "192.168.0.10"
      ];
      memcache.local = "\\OC\\Memcache\\APCu";
      filelocking.enabled = true;
    };

    config.adminpassFile = "${pkgs.writeText "adminpass" "test123"}";
  };
}
