{ pkgs, ... }:
{
  systemd.user.services.pm2 = {
    Unit.Description = "Pm2 start on boot";
    Service = {
      ExecStart= "${pkgs.nodePackages.pm2}/bin/pm2 resurrect";
      ExecReload= "${pkgs.nodePackages.pm2}/bin/pm2 reload all";
      ExecStop= "${pkgs.nodePackages.pm2}/bin/pm2 kill";
      LimitNOFILE= "infinity";
      LimitNPROC= "infinity";
      LimitCORE= "infinity";
      Environment= "PM2_HOME=/home/emanuel/.pm2 PATH=/run/wrappers/bin:/home/emanuel/.nix-profile/bin:/etc/profiles/per-user/emanuel/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:${pkgs.nodejs_20}/bin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin";
      PIDFile= "/home/emanuel/.pm2/pm2.pid";
      StateDirectory= "pm2";
      Restart= "on-failure";
      Type= "forking";
      WantedBy= [ "multi-user.target" ];
    };
    Install = {
      WantedBy= [ "multi-user.target" ];
    };
  };
}
