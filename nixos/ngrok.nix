{lib, config, pkgs, ... }:
{

 systemd.user.services.ngrok = {
   description = "ngrok";
   serviceConfig = {
     Type = "forking";
     ExecStart = "${pkgs.ngrok}/bin/ngrok tcp 22";
   };
	 after = [ "network.target" ];
   wantedBy = [ "default.target" ];
 };

 systemd.services.ngrok.enable = true;

}
