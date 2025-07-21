{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    fish                      # Smart and user-friendly command line shell
    git                       # Distributed version control system
    neovim                    # Vim text editor fork focused on extensibility and agility
    nh                        # Yet another nix cli helper
    nix-output-monitor        # Processes output of Nix commands to show helpful and pretty information
    yazi                      # Blazing fast terminal file manager written in Rust, based on async I/O
  ];
}
