{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    ncmpcpp
  ];

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

  services.mpd-mpris.enable = true;
}
