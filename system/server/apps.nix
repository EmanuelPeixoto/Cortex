{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    czkawka-full
    fish
    git
    neovim
    nh
    nix-output-monitor
    yazi
  ];
}
