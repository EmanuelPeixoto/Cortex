{
  services = {
    nextcloud.config = {
      dbtype = "sqlite";
    };
  };

  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };
}
