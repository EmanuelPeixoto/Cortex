{ pkgs, ... }:
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
