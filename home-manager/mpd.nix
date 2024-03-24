{lib, config, pkgs, ... }:
{
  services.mpd = {
    enable = true;
    musicDirectory = "/home/emanuel/Nextcloud/Musicas";
    network.listenAddress = "any";
    extraConfig = ''
      audio_output {
        type "pulse"
        name "Pulseaudio"
        server "127.0.0.1" # add this line - MPD must connect to the local sound server
      }
    '';
  };

  services.mpd-mpris.enable = true;
}
