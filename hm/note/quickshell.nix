{ pkgs, ... }:
let
  CustomQS = pkgs.quickshell.overrideAttrs (prev: {
    buildInputs = prev.buildInputs ++ [ pkgs.qt6.qt5compat ];
  });
in
{
  home.packages = [ CustomQS ];

  xdg.configFile."quickshell".source = ./quickshell;

  systemd.user.services.quickshell = {
    Unit = {
      Description = "Quickshell";
      PartOf = [ "hyprland-session.target" ];
      After = [ "hyprland-session.target" ];
    };
    Service = {
      ExecStart = "${CustomQS}/bin/quickshell";
      Restart = "no";
      KillMode = "process";
      Environment = [
        "QT_QPA_PLATFORM=wayland"
        "QT_APPLICATION_NAME=quickshell"
        "DESKTOP_ENTRY=quickshell"
        "XDP_IGNORE_APP_ID=1"
        "QT_LOGGING_RULES=qt.qpa.services.warning=false"
      ];
    };
    Install.WantedBy = ["hyprland-session.target"];
  };
}
