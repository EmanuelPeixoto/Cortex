{ config, pkgs, ... }:
{
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Nextcloud/Musicas";
    network.listenAddress = "any";
    extraConfig = ''
      bind_to_address "::"
      zeroconf_enabled "no"

      # Remote clients (phone) need a password; local clients (rmpc, mpris)
      # keep full access without one. See ~/.config/mpd/secret.conf.
      default_permissions "read"
      local_permissions "read,add,control,admin"
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
