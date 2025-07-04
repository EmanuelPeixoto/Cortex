{ config, inputs, pkgs, ... }:
let
  ags = inputs.ags.packages.${pkgs.system};
in
  {
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;
    systemd.enable = true;
    configDir = ./ags;
    extraPackages = [
      ags.apps
      ags.astal4
      ags.battery
      ags.hyprland
      ags.mpris
      ags.network
      ags.tray
      ags.wireplumber
      pkgs.pwvucontrol
    ];
  };

  systemd.user.services.ags = {
    Unit = {
      PartOf = [ "hyprland-session.target" ];
      After = [ "hyprland-session.target" ];
    };
    Install.WantedBy = [ "hyprland-session.target" ];
  };
}
