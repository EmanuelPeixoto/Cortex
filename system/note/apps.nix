{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    neovim
    nh
    nix-output-monitor
    nvd
    powertop
  ];
}
