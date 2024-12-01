{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.meslo-lg
    ];


    fontconfig.defaultFonts = {
      serif = [ "MesloLGSNerdFont" ];
      sansSerif = [ "MesloLGSNerdFont" ];
      monospace = [ "MesloLGSNerdFont" ];
    };
  };
}
