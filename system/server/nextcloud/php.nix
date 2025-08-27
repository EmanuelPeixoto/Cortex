{
  services.nextcloud = {
    poolSettings = {
      pm = "dynamic";
      "pm.max_children" = "60";
      "pm.start_servers" = "6";
      "pm.min_spare_servers" = "4";
      "pm.max_spare_servers" = "12";
      "pm.max_requests" = "500";
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
