{ pkgs, ... }:
{
  imports = [
    ../shared/btop.nix
    ../shared/git.nix
    ../shared/lexis.nix
    ../shared/yazi.nix
    ../shared/zsh.nix
  ];

  home = {
    homeDirectory = "/home/emanuel";
    stateVersion = "23.11";
    username = "emanuel";

    sessionVariables = {
      EDITOR = "nvim";
    };

    packages = with pkgs; [
      curl                      # Command line tool for transferring files with URL syntax
      ffmpeg                    # Complete, cross-platform solution to record, convert and stream audio and video
      gcc                       # GNU Compiler Collection
      iftop                     # Display bandwidth usage on a network interface
      lazygit                   # Simple terminal UI for git commands
      lm_sensors                # Tools for reading hardware sensors
      neofetch                  # Fast, highly customizable system info script
      nload                     # Monitors network traffic and bandwidth usage with ncurses graphs
      pciutils                  # Collection of programs for inspecting and manipulating configuration of PCI devices
      progress                  # Tool that shows the progress of coreutils programs
      speedtest-cli             # Command line interface for testing internet bandwidth using speedtest.net
      unzip                     # Extraction utility for archives compressed in .zip format
      ventoy                    # New Bootable USB Solution
      wget                      # Tool for retrieving files using HTTP, HTTPS, and FTP
      wl-clipboard              # Command-line copy/paste utilities for Wayland
      yt-dlp                    # Command-line tool to download videos from YouTube.com and other sites (youtube-dl fork)
      zip                       # Compressor/archiver for creating and modifying zipfiles
    ];
  };

  programs.home-manager.enable = true;
}
