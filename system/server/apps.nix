{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    fish
    git
    neovim
    nh
    nix-output-monitor
    yazi
  ];
}
