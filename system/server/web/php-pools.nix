{ config, lib, pkgs, poolName ? "default", user ? "nginx", group ? "www" }:

{
  services.phpfpm.pools."${poolName}" = {
    inherit user group;
    phpEnv."PATH" = lib.makeBinPath [ pkgs.php ];

    settings = {
      "listen.owner" = config.services.nginx.user;

      # Process management
      "pm" = "dynamic";
      "pm.max_children" = 5;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 3;
      "pm.max_requests" = 1000;

      # Memory limits
      "php_admin_value[memory_limit]" = "128M";

      # Error logging
      "php_admin_value[error_log]" = "stderr";
      "php_admin_flag[log_errors]" = true;
      "catch_workers_output" = true;

      # Opcache configuration (lightweight)
      "php_admin_flag[opcache.enable]" = true;
      "php_admin_value[opcache.memory_consumption]" = "64";
      "php_admin_value[opcache.interned_strings_buffer]" = "8";
      "php_admin_value[opcache.max_accelerated_files]" = "10000";
      "php_admin_value[opcache.validate_timestamps]" = "1";
      "php_admin_value[opcache.revalidate_freq]" = "2";
      "php_admin_value[opcache.jit]" = "off";
    };
  };
}
