{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git                       # Distributed version control system
    neovim                    # Vim text editor fork focused on extensibility and agility
    nh                        # Yet another nix cli helper
    nix-output-monitor        # Processes output of Nix commands to show helpful and pretty information
    nvd                       # Nix/NixOS package version diff tool
    powertop                  # Analyze power consumption on Intel-based laptops
  ];
}
