{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Meslo" ];})
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "MesloLGSNerdFontMono" ];
        sansSerif = [ "MesloLGSNerdFont" ];
        monospace = [ "MesloLGSNerdFont" ];
      };
    };
  };
}
