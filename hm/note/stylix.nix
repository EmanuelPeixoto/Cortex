{ config, inputs, pkgs, ... }:
{
  imports = [ inputs.stylix.homeModules.stylix ];

  home.packages = with pkgs; [
    nerd-fonts.meslo-lg
  ];

  gtk.gtk4.theme = config.gtk.theme;

  stylix = {
    enable = true;
    enableReleaseChecks = false;
    targets = {
      qt.enable = true;
      firefox.profileNames = [ "default" ];
      zen-browser.profileNames = [ "default" ];
    };

    base16Scheme = "${pkgs.base16-schemes}/share/themes/oxocarbon-dark.yaml";
    polarity = "dark";

    fonts = {
      serif = {
        package = pkgs.nerd-fonts.meslo-lg;
        name = "MesloLGS Nerd Font";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.meslo-lg;
        name = "MesloLGS Nerd Font";
      };
      monospace = {
        package = pkgs.nerd-fonts.meslo-lg;
        name = "MesloLGS Nerd Font Mono";
      };
      emoji = {
        package = pkgs.nerd-fonts.meslo-lg;
        name = "MesloLGS Nerd Font";
      };
    };

    icons = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

    cursor = {
      name = "Dracula-cursors";
      package = pkgs.dracula-theme;
      size = 30;
    };
  };
}
