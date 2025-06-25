{ config, pkgs, ... }:
{
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Nextcloud/Musicas";
    network.listenAddress = "any";
    extraConfig = ''
      audio_output {
      type "pipewire"
      name "MPD pipewire"
      }
    '';
  };

  programs.rmpc.enable = true;

  services.mpd-mpris.enable = true;
}
