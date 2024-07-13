{ pkgs, ... }:
let
  Path = "/SCTI/src";
in
{
  systemd.services.goscti = {
    enable = true;
    description = "Go SCTI service";
    serviceConfig = {
      ExecStart = ''${pkgs.zsh}/bin/zsh -c "cd ${Path} && ${pkgs.go}/bin/go run ." '';
      User = "emanuel";
      Group = "users";
      Restart = "on-failure";
      RestartSec = "5s";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
