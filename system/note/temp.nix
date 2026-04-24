{ pkgs, ... }:
let
  cfg = import ../server/nextcloud/domain.nix;
in
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
  };

  environment.systemPackages = with pkgs; [
    # chromium
    cheese
  ];

  # networking.extraHosts = ''
  #   192.168.0.10   ${cfg.noteDomain}
  # '';
}
