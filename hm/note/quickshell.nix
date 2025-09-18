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
    };
    Install.WantedBy = ["hyprland-session.target"];
  };
}
