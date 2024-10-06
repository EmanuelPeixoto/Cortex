{ config, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.sessionVariables.FLAKE = "${config.users.users.emanuel.home}/Cortex";
}
