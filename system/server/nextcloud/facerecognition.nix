{ config, pkgs, ... }:
let
  occ = "/run/current-system/sw/bin/nextcloud-occ";
  facerecognitionApp = pkgs.callPackage ./facerecognition-app.nix { };
  nextcloudUser = "root";
  # DLib is CPU-bound and each worker spawns its own multi-threaded pool
  # (dlib ~20 + OpenBLAS ~20). Empirically best on this 20-thread box: 16
  # workers (~88% user CPU). Forcing single-thread hurts throughput.
  workers = 16;
in
{
  services.nextcloud = {
    # Keep the app store enabled so recognize and other store-apps keep working.
    appstoreEnable = true;
    extraApps.facerecognition = facerecognitionApp;
  };

  system.activationScripts.nextcloud-facerecognition = {
    deps = [ "var" ];
    text = ''
      ${occ} app:enable facerecognition 2>/dev/null || true

      # Install the DLib models (idempotent) and assign memory for image processing.
      # Model 1 = CNN detector + 5-point landmarks + ResNet-34 descriptor.
      ${occ} face:setup -m 1 -M 1536M 2>&1 || true
      # Model 4 = Model 1 detection + HOG validation (fewer clustering errors).
      # It reuses Model 1, so it must be installed first.
      ${occ} face:setup -m 4 2>&1 || true

      # Recognize also detects faces; disable it to avoid double processing.
      ${occ} app:disable recognize 2>/dev/null || true
    '';
  };

  systemd.services.nextcloud-face = {
    description = "Nextcloud Face Recognition – background job";
    after = [ "phpfpm-nextcloud.service" ];
    requires = [ "phpfpm-nextcloud.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${occ} face:background_job -u ${nextcloudUser} -w ${toString workers} -t 3500";
      User = "nextcloud";
      Group = "nextcloud";
      TimeoutStartSec = "3600";
      StandardOutput = "null";
      StandardError = "null";
    };
  };

  systemd.timers.nextcloud-face = {
    wantedBy = [ "timers.target" ];
    unitConfig.Description = "Nextcloud Face Recognition – hourly pipeline";
    timerConfig = {
      OnCalendar = "hourly";
      Persistent = true;
    };
  };
}
