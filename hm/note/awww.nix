{ pkgs, ... }:
{
  home.packages = with pkgs; [
    awww
  ];

  services.awww.enable = true;

  systemd.user.services.awww = {
    Unit = {
      PartOf = [ "hyprland-session.target" ];
      After = [ "hyprland-session.target" ];
    };
    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
      StandardOutput = "null";
      StandardError = "null";
    };
    Install.WantedBy = [ "hyprland-session.target" ];
  };

}
