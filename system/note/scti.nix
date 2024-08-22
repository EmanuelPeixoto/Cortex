{ pkgs, ... }:
{
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    ensureDatabases = [ "scti-db" ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database DBuser auth-method
      local all      all    trust
      #type database DBuser Address      auth-method
      host  all      all    127.0.0.1/32 trust
      host  all      all    ::1/128      trust
    '';
  };
}
