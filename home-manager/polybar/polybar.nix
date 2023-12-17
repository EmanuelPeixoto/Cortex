{lib, config, pkgs, ... }:
{


services.polybar = {
  package = pkgs.polybarFull;
  enable = true;
  script = "polybar barra &";
  config = ./config.ini;
};

}
