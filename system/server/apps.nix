{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    czkawka-full
    exiftool
    fish
    git
    neovim
    nh
    nix-output-monitor
    yazi
  ];
}
