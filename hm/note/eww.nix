{ config, pkgs, ... }:
let
  colors = config.colorScheme.palette;

  generateScss = ''
    // Colors generated from nix-colors
    $background: #${colors.background};
    $border: #${colors.border};
    $font: #${colors.font};
    $idle: #${colors.idle};
    $main: #${colors.main};
  '';
in
{
  home.packages = with pkgs; [
    pwvucontrol
    socat
  ];

  programs.eww = {
    enable = true;
    configDir = ./eww;
    enableZshIntegration = true;
  };

  home.file."${config.home.homeDirectory}/.config/Cortex/hm/note/eww/colors.scss".text = generateScss;

  systemd.user.services.eww = {
    Unit = {
      Description = "Eww Daemon";
    };
    Service = {
      ExecStart = "${pkgs.eww}/bin/eww daemon --no-daemonize";
      Restart = "no";
    };
    Install.WantedBy = ["hyprland-session.target"];
  };
}
