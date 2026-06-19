{ pkgs, ... }:
let
  occ = "/run/current-system/sw/bin/nextcloud-occ";
  nodeBin = "${pkgs.nodejs_20}/bin/node";
  ffmpegBin = "${pkgs.ffmpeg}/bin/ffmpeg";
  niceBin = "${pkgs.coreutils}/bin/nice";
in
  {
  system.activationScripts.nextcloud-recognize-app = {
    deps = [ "var" ];
    text = ''
      ${occ} app:enable recognize 2>/dev/null || true

      ${occ} config:app:set recognize node_binary --value="${nodeBin}"
      ${occ} config:app:set recognize ffmpeg_binary --value="${ffmpegBin}"
      ${occ} config:app:set recognize nice_binary --value="${niceBin}"

      ${occ} config:app:set recognize tensorflow.gpu --value="false"
      ${occ} config:app:set recognize tensorflow.purejs --value="true"
      ${occ} config:app:set recognize tensorflow.cores --value="0"

      ${occ} config:app:set recognize faces.enabled --value="true"
      ${occ} config:app:set recognize imagenet.enabled --value="true"
      ${occ} config:app:set recognize landmarks.enabled --value="true"
      ${occ} config:app:set recognize musicnn.enabled --value="false"
      ${occ} config:app:set recognize movinet.enabled --value="false"

      ${occ} config:app:set recognize faces.batchSize --value="5"
      ${occ} config:app:set recognize imagenet.batchSize --value="500"
      ${occ} config:app:set recognize landmarks.batchSize --value="100"
    '';
  };

  systemd.services = {
    nextcloud-recognize-classify = {
      description = "Nextcloud Recognize – Classify queued files";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${occ} recognize:classify";
        User = "nextcloud";
        Group = "nextcloud";
        TimeoutStartSec = "6h";
      };
      environment = {
        LD_LIBRARY_PATH = "/run/opengl-driver/lib";
      };
    };

    nextcloud-recognize-cluster = {
      description = "Nextcloud Recognize – Cluster faces into people";
      after = [ "nextcloud-recognize-classify.service" ];
      requires = [ "nextcloud-recognize-classify.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${occ} recognize:cluster-faces";
        User = "nextcloud";
        Group = "nextcloud";
        TimeoutStartSec = "2h";
      };
    };
  };

  systemd.timers.nextcloud-recognize-classify = {
    wantedBy = [ "timers.target" ];
    unitConfig.Description = "Nextcloud Recognize – hourly pipeline trigger";
    timerConfig = {
      OnCalendar = "hourly";
      Persistent = true;
    };
  };
}
