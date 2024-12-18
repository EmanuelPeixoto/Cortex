{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    git                       # Distributed version control system
    nh                        # Yet another nix cli helper
    nix-output-monitor        # Processes output of Nix commands to show helpful and pretty information
  ];
}
