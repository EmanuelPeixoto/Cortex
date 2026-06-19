{
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [{
      name = "nextcloud";
      ensureDBOwnership = true;
    }];
  };

  services.nextcloud.config = {
    dbtype  = "pgsql";
    dbname  = "nextcloud";
    dbuser  = "nextcloud";
    dbhost  = "/run/postgresql";
  };

  systemd.services.nextcloud-setup = {
    requires = [ "postgresql.service" ];
    after    = [ "postgresql.service" ];
  };
}
