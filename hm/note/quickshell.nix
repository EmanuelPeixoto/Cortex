{ inputs, ... }:
{
  home.packages = [
    inputs.quickshell.packages."x86_64-linux".default
  ];

  xdg.configFile."quickshell".source = ./quickshell;

  systemd.user.services.quickshell = {
    Unit = {
      Description = "Quickshell";
      PartOf = [ "hyprland-session.target" ];
      After = [ "hyprland-session.target" ];
    };
    Service = {
      ExecStart = "${inputs.quickshell.packages."x86_64-linux".default}/bin/quickshell";
      Restart = "no";
    };
    Install.WantedBy = ["hyprland-session.target"];
  };
}
