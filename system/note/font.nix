{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Meslo" ];})
    ];


    fontconfig.defaultFonts = {
      serif = [ "MesloLGSNerdFont" ];
      sansSerif = [ "MesloLGSNerdFont" ];
      monospace = [ "MesloLGSNerdFont" ];
    };
  };
}
