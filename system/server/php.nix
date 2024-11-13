{ config, lib, pkgs, ... }:
{
  services.phpfpm.pools.one = {
    user = "nginx";
    group = "www";
    phpEnv."PATH" = lib.makeBinPath [ pkgs.php ];

    settings = {
      "listen.owner" = config.services.nginx.user;
      "pm" = "dynamic";
      "pm.max_children" = 32;
      "pm.max_requests" = 500;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 2;
      "pm.max_spare_servers" = 5;
      "php_admin_value[error_log]" = "stderr";
      "php_admin_flag[log_errors]" = true;
      "catch_workers_output" = true;
    };
  };
}
