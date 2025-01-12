{ config, inputs, pkgs, ... }:
let
  colors = config.colorScheme.palette;

  generateScss = ''
    // Colors generated from nix-colors
    $bg: #${colors.background};
    $border: #${colors.border};
    $text: #${colors.font};
    $main: #${colors.main};
  '';
in
  {
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;

    configDir = ./ags;

    extraPackages = with pkgs; [
      libdbusmenu-gtk3
      upower
      gtk3
      gtk-layer-shell
      networkmanager
      pulseaudio
    ] ++ (with inputs.ags.packages.${pkgs.system}; [
        battery
        hyprland
        mpris
        network
        tray
        wireplumber
      ]
      );
  };

  home.file."${config.home.homeDirectory}/.config/Cortex/hm/note/ags/Bar/Variables.scss".text = generateScss;

  systemd.user.services.agsbar = {
    Service = {
      ExecStart = "${config.programs.ags.package}/bin/ags run";
      Environment = "GI_TYPELIB_PATH=${pkgs.gobject-introspection.dev}/lib/girepository-1.0:${config.programs.ags.package}/lib/girepository-1.0";
      Restart = "no";
    };
    Install.WantedBy = ["hyprland-session.target"];
  };}

