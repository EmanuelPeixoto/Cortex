{ config, ... }:
{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    extra-platforms = [ "i686-linux" ];
  };
  environment.sessionVariables.NH_FLAKE = "${config.users.users.emanuel.home}/.config/Cortex";
}
