{ config, pkgs, ... }:
let
  # Ly's shell session runs through the NixOS session wrapper, which pipes
  # stdout/stderr into `systemd-cat` (journal) — swallowing all TTY output.
  # Bypass that redirect for shell (tty) sessions.
  setupCmd = pkgs.writeShellScript "ly-setup" ''
    [ "''${XDG_SESSION_TYPE:-}" = "tty" ] && export _DID_SYSTEMD_CAT=1
    exec ${config.services.displayManager.sessionData.wrapper} "$@"
  '';
in
{
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "matrix";
      clock = "%d/%m/%y - %R";
      xinitrc = "null";
      setup_cmd = "${setupCmd}";
      brightness_down_cmd = "${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
      brightness_down_key = "F5";
      brightness_up_cmd = "${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
      brightness_up_key = "F6";
    };
  };
}
