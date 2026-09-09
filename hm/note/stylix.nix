{
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [ inputs.stylix.homeModules.stylix ];

  home.packages = with pkgs; [
    nerd-fonts.meslo-lg
  ];

  stylix = {
    enable = true;
    enableReleaseChecks = false;
    targets = {
      hyprland.enable = true;
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
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 15;
    };
  };

  # home.pointerCursor only exports XCURSOR_* to login shells.
  # Apps launched by systemd services (noctalia → KeePassXC) don't inherit it,
  # so Qt uses the default size (24) and the cursor is larger than the compositor's.
  # Also propagate to systemd to match the size (15 above).
  systemd.user.sessionVariables = {
    XCURSOR_SIZE = toString config.stylix.cursor.size;
    XCURSOR_THEME = config.stylix.cursor.name;
  };
}
