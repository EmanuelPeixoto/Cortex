{ config, ... }:
{
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Nextcloud/Musicas";
    network.listenAddress = "any";
    extraConfig = ''
      bind_to_address "::"
      zeroconf_enabled "no"

      default_permissions "read"
      host_permissions "::1 read,add,control,admin"
      host_permissions "[::ffff:127.0.0.1] read,add,control,admin"
      include_optional "${config.home.homeDirectory}/.config/mpd/secret.conf"

      audio_output {
      type "pipewire"
      name "MPD pipewire"
      }
    '';
  };

  programs.rmpc.enable = true;

  services.mpd-mpris.enable = true;
}
