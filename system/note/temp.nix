{ pkgs, ... }:
let
  cfg = import ../server/nextcloud/domain.nix;
in
{
  environment.systemPackages = with pkgs; [
    # chromium
  ];

  # networking.extraHosts = ''
  #   192.168.0.10   ${cfg.Domain}
  # '';
}
