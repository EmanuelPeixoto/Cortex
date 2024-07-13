{ ... }:
{
  systemd.services.goscti = {
    enable = true;
    description = "Go SCTI service";
    serviceConfig = {
      ExecStart = "/home/emanuel/SCTI/src/main";
      # StateDirectory = "GoSCTI";
      Type = "forking";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
