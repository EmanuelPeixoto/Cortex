{ inputs, pkgs, ... }:

{
  imports = [
    inputs.stylix.homeModules.stylix
  ];

  home.packages = with pkgs; [
    nerd-fonts.meslo-lg
  ];

  stylix = {
    enable = true;
    targets.qt.enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/oxocarbon-dark.yaml";
    polarity = "dark";

    fonts = {
      serif = {
        package = pkgs.nerd-fonts.meslo-lg;
        name = "MesloLGSNerdFont";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.meslo-lg;
        name = "MesloLGSNerdFont";
      };
      monospace = {
        package = pkgs.nerd-fonts.meslo-lg;
        name = "MesloLGSNerdFont";
      };
      emoji = {
        package = pkgs.nerd-fonts.meslo-lg;
        name = "MesloLGSNerdFont";
      };
    };

    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
    };

    cursor = {
      name = "Dracula-cursors";
      package = pkgs.dracula-theme;
      size = 30;
    };
  };
}
