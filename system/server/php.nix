{ config, lib, pkgs, ... }:
{
  services.phpfpm.pools.one = {
    user = "nginx";
    group = "www";
    phpEnv."PATH" = lib.makeBinPath [ pkgs.php ];

    settings = {
      "listen.owner" = config.services.nginx.user;
      "pm" = "dynamic";
      "pm.max_children" = 60;
      "pm.max_requests" = 500;
      "pm.start_servers" = 4;
      "pm.min_spare_servers" = 4;
      "pm.max_spare_servers" = 10;
      "php_admin_value[memory_limit]" = "16G";
      "php_admin_value[error_log]" = "stderr";
      "php_admin_flag[log_errors]" = true;
      "catch_workers_output" = true;
      "php_admin_flag[opcache.enable]" = true;
      "php_admin_value[opcache.memory_consumption]" = "256";
      "php_admin_value[opcache.interned_strings_buffer]" = "32";
      "php_admin_value[opcache.max_accelerated_files]" = "20000";
      "php_admin_value[opcache.validate_timestamps]" = "0";
      "php_admin_value[opcache.revalidate_freq]" = "0";
      "php_admin_value[opcache.jit]" = "tracing";
      "php_admin_value[opcache.jit_buffer_size]" = "100M";
    };
  };
}
