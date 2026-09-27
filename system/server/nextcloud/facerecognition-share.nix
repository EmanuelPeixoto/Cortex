{ config, pkgs, ... }:
let
  occ = "/run/current-system/sw/bin/nextcloud-occ";

  shareSql = pkgs.writeText "facerecognition-share.sql" ''
    BEGIN;

    CREATE TEMP TABLE _fr_shared_img ON COMMIT DROP AS
    SELECT g.id AS img_id
      FROM oc_facerecog_images g
      JOIN oc_facerecog_images r ON r."user" = 'root' AND r.file = g.file AND r.model = g.model
     WHERE g."user" = :'target_user';

    UPDATE oc_facerecog_faces
       SET cluster = NULL
     WHERE image IN (SELECT id FROM oc_facerecog_images WHERE "user" = :'target_user')
       AND image NOT IN (SELECT img_id FROM _fr_shared_img);

    DELETE FROM oc_facerecog_faces WHERE image IN (SELECT img_id FROM _fr_shared_img);
    DELETE FROM oc_facerecog_clusters WHERE "user" = :'target_user';
    DELETE FROM oc_facerecog_persons  WHERE "user" = :'target_user';

    CREATE TEMP TABLE _fr_map_person ON COMMIT DROP AS
    SELECT p.id AS root_id, nextval('oc_facerecog_persons_id_seq') AS new_id, p.name
      FROM oc_facerecog_persons p WHERE p."user" = 'root' ORDER BY p.id;

    INSERT INTO oc_facerecog_persons (id, "user", name)
    SELECT new_id, :'target_user', name FROM _fr_map_person;

    CREATE TEMP TABLE _fr_map_cluster ON COMMIT DROP AS
    SELECT c.id AS root_id, nextval('oc_facerecog_clusters_id_seq') AS new_id,
           c.person AS root_person, c.model, c.is_visible
      FROM oc_facerecog_clusters c WHERE c."user" = 'root' ORDER BY c.id;

    INSERT INTO oc_facerecog_clusters (id, "user", model, is_visible, person)
    SELECT mc.new_id, :'target_user', mc.model, mc.is_visible, mp.new_id
      FROM _fr_map_cluster mc LEFT JOIN _fr_map_person mp ON mp.root_id = mc.root_person;

    INSERT INTO oc_facerecog_faces
           (image, x, y, width, height, is_groupable, confidence, landmarks, descriptor, creation_time, cluster)
    SELECT g.id, f.x, f.y, f.width, f.height, f.is_groupable, f.confidence,
           f.landmarks, f.descriptor, f.creation_time, mc.new_id
      FROM oc_facerecog_faces f
      JOIN oc_facerecog_images r ON r.id = f.image AND r."user" = 'root'
      JOIN oc_facerecog_images g ON g."user" = :'target_user' AND g.file = r.file AND g.model = r.model
      LEFT JOIN _fr_map_cluster mc ON mc.root_id = f.cluster;

    UPDATE oc_facerecog_images g
       SET is_processed = true, is_refined = true, error = NULL,
           last_processed_time = now(), processing_duration = 0
     WHERE g."user" = :'target_user'
       AND EXISTS (SELECT 1 FROM oc_facerecog_images r
                    WHERE r."user" = 'root' AND r.file = g.file AND r.model = g.model
                      AND r.is_processed = true);

    COMMIT;
  '';

  shareScript = pkgs.writeShellScript "nextcloud-face-share" ''
    set -euo pipefail
    psql_bin="${config.services.postgresql.package}/bin/psql"

    ${occ} config:app:set facerecognition handle_shared_files --value true >/dev/null 2>&1 || true

    for user in genilma leandro; do
      ${occ} user:setting "$user" facerecognition enabled true >/dev/null 2>&1 || true
      ${occ} user:setting "$user" facerecognition recreate_clusters false >/dev/null 2>&1 || true
      ${occ} face:background_job --user_id "$user" --sync-mode -t 1800 >/dev/null 2>&1 || true
      "$psql_bin" -h /run/postgresql -d nextcloud -v ON_ERROR_STOP=1 -v "target_user=$user" -f ${shareSql}
    done
  '';
in
{
  systemd.services.nextcloud-face-share = {
    description = "Nextcloud Face Recognition – share names with genilma and leandro";
    after = [ "phpfpm-nextcloud.service" ];
    requires = [ "phpfpm-nextcloud.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${shareScript}";
      User = "nextcloud";
      Group = "nextcloud";
      TimeoutStartSec = "3600";
    };
  };

  systemd.timers.nextcloud-face-share = {
    wantedBy = [ "timers.target" ];
    unitConfig.Description = "Nextcloud Face Recognition – share names hourly";
    timerConfig = {
      OnCalendar = "*-*-* *:30:00";
      Persistent = true;
    };
  };
}
