{ ... }:
{
  systemd.services.noip = {
    enable = false; # my router is doing this
    description = "Go SCTI service";
    serviceConfig = {
      ExecStart = "/home/emanuel/SCTI/src/main";
      # StateDirectory = "GoSCTI";
      Type = "forking";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
