{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    git
    home-manager
    nh
    nix-output-monitor
    nvd
    powertop
  ];


}
