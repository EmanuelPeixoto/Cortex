{ pkgs, ... }:
let
  occ = "/run/current-system/sw/bin/nextcloud-occ";

  tfjsPath = "/var/lib/nextcloud/recognize-tfjs";
  appPath = "/var/lib/nextcloud/store-apps/recognize";
  tfjsNodeModule = "${tfjsPath}/node_modules/@tensorflow/tfjs-node";
  appTensorflowDir = "${appPath}/node_modules/@tensorflow";
  appTfjsLink = "${appTensorflowDir}/tfjs-node";

  # Wrapper to inject tfjs-node and force localhost binding
  nodeBinSafe = pkgs.writeShellScriptBin "node-localhost" ''
    export SERVER_HOST=127.0.0.1
    export HOST=127.0.0.1
    export NODE_PATH="${tfjsPath}/node_modules''${NODE_PATH:+:}$NODE_PATH"
    export LD_LIBRARY_PATH="${pkgs.stdenv.cc.libc}/lib:${pkgs.stdenv.cc.cc.lib}/lib''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
    export TF_NUM_INTRAOP_THREADS=20
    export TF_NUM_INTEROP_THREADS=4
    exec ${pkgs.nodejs_22}/bin/node "$@"
  '';
  nodeBin = "${nodeBinSafe}/bin/node-localhost";
  ffmpegBin = "${pkgs.ffmpeg}/bin/ffmpeg";
  niceBin = "${pkgs.coreutils}/bin/nice";
in
  {
  system.activationScripts.nextcloud-recognize-app = {
    deps = [ "var" ];
    text = ''
      ${occ} app:enable recognize 2>/dev/null || true

      # Install native TensorFlow (multi-core) on first run
      if [ ! -d "${tfjsNodeModule}/lib/napi-v8" ]; then
        mkdir -p ${tfjsPath} || true
        cd ${tfjsPath}
        export PATH="${pkgs.stdenv.cc}/bin:${pkgs.bash}/bin:${pkgs.gnumake}/bin:${pkgs.nodejs_22}/bin:$PATH"
        npm init -y --silent 2>/dev/null || true
        npm install @tensorflow/tfjs-node@4.22.0 --no-audit --no-fund 2>&1 || true
        chown -R nextcloud:nextcloud ${tfjsPath} || true
        ${pkgs.patchelf}/bin/patchelf \
          --set-interpreter ${pkgs.stdenv.cc.libc}/lib/ld-linux-x86-64.so.2 \
          --set-rpath ${pkgs.stdenv.cc.libc}/lib:${pkgs.stdenv.cc.cc.lib}/lib \
          "$(find ${tfjsPath} -name tfjs_binding.node -print -quit)" 2>/dev/null || true
        find ${tfjsPath} -name "libtensorflow.so*" -exec ${pkgs.patchelf}/bin/patchelf \
          --set-rpath ${pkgs.stdenv.cc.libc}/lib:${pkgs.stdenv.cc.cc.lib}/lib {} \; 2>/dev/null || true
      fi

      # Symlink tfjs-node into the Recognize app so it can find the native backend
      mkdir -p ${appTensorflowDir} || true
      rm -rf ${appTfjsLink} 2>/dev/null || true
      ln -sfn ${tfjsNodeModule} ${appTfjsLink} || true
      chown -h nextcloud:nextcloud ${appTfjsLink} || true

      ${occ} config:app:set recognize node_binary --value="${nodeBin}"
      ${occ} config:app:set recognize ffmpeg_binary --value="${ffmpegBin}"
      ${occ} config:app:set recognize nice_binary --value="${niceBin}"

      ${occ} config:app:set recognize tensorflow.gpu --value="false"
      ${occ} config:app:set recognize tensorflow.purejs --value="false"
      ${occ} config:app:set recognize tensorflow.cores --value="0"

      ${occ} config:app:set recognize concurrency.enabled --value="true"
      ${occ} config:app:set recognize concurrency.maxProcesses --value="8"

      ${occ} config:app:set recognize faces.enabled --value="true"
      ${occ} config:app:set recognize imagenet.enabled --value="false"
      ${occ} config:app:set recognize landmarks.enabled --value="true"
      ${occ} config:app:set recognize musicnn.enabled --value="false"
      ${occ} config:app:set recognize movinet.enabled --value="false"

      ${occ} config:app:set recognize faces.batchSize --value="50"
      ${occ} config:app:set recognize imagenet.batchSize --value="500"
      ${occ} config:app:set recognize landmarks.batchSize --value="500"
    '';
  };

  systemd.services = {
    nextcloud-recognize-classify = {
      description = "Nextcloud Recognize – Classify queued files";
      after = [ "phpfpm-nextcloud.service" ];
      requires = [ "phpfpm-nextcloud.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${occ} recognize:classify";
        User = "nextcloud";
        Group = "nextcloud";
        TimeoutStartSec = "6h";
        StandardOutput = "null";
        StandardError = "null";
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
        StandardOutput = "null";
        StandardError = "null";
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
