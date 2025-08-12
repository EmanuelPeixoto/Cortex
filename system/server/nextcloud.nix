{ config, pkgs, ... }:
let
  occ = "/run/current-system/sw/bin/nextcloud-occ";
  nextcloudUser = "root";
  analyzeJobs = 10;
in
{
  services.nextcloud = {
    enable = true;
    https = true;
    hostName = "epeixoto.ddns.net";
    package = pkgs.nextcloud31;
    maxUploadSize = "10240M";

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
      dbtype = "sqlite";
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

  systemd = {
    services = {
      nextcloud-face-sync = {
        description = "Nextcloud Face Recognition Sync Mode";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${occ} face:background_job -u ${nextcloudUser} --sync-mode";
          User = "nextcloud";
          Group = "nextcloud";
        };
        after = [ "nextcloud-setup.service" ];
        wants = [ "nextcloud-setup.service" ];
      };

      nextcloud-face-cluster = {
        description = "Nextcloud Face Recognition Cluster Mode";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${occ} face:background_job -u ${nextcloudUser} --cluster-mode";
          User = "nextcloud";
          Group = "nextcloud";
        };
        after = [ "nextcloud-setup.service" ];
        wants = [ "nextcloud-setup.service" ];
      };

      # Template para múltiplas instâncias de analyze-mode
      "nextcloud-face-analyze@" = {
        description = "Nextcloud Face Recognition Analyze Mode Instance %i";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${occ} face:background_job -u ${nextcloudUser} --analyze-mode";
          User = "nextcloud";
          Group = "nextcloud";
        };
        after = [ "nextcloud-setup.service" ];
        wants = [ "nextcloud-setup.service" ];
      };

      nextcloud-face-analyze-parallel-run = {
        description = "Run multiple analyze instances in parallel";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "nextcloud-face-parallel" ''
            for i in $(seq 1 ${toString analyzeJobs}); do
              systemctl start nextcloud-face-analyze@$i.service &
            done
            wait
          '';
          User = "root";
        };
        after = [ "nextcloud-setup.service" ];
        wants = [ "nextcloud-setup.service" ];
      };
    };

    # Timer para disparar análise paralela em N instâncias
    timers.nextcloud-face-analyze-parallel = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "hourly";
        Persistent = true;
      };
      unitConfig = {
        Description = "Run Nextcloud face analyze parallel jobs";
        Requires = "nextcloud-face-analyze-parallel-run.service";
      };
    };
  };
}
