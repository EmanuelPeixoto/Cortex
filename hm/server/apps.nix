{ pkgs, ... }:
let
  catfolder = import ../shared/scripts/catfolder.nix { inherit pkgs; };
  motd = import ../shared/scripts/motd.nix { inherit pkgs; };
  yt-tlp-menu = import ../shared/scripts/yt-dlp-menu.nix { inherit pkgs; };
in
{
  home.packages = with pkgs; [
    catfolder
    motd
    yt-tlp-menu

    curl                      # Command line tool for transferring files with URL syntax
    ffmpeg                    # Complete, cross-platform solution to record, convert and stream audio and video
    gcc                       # GNU Compiler Collection
    iftop                     # Display bandwidth usage on a network interface
    lazygit                   # Simple terminal UI for git commands
    lm_sensors                # Tools for reading hardware sensors
    ncdu                      # Disk usage analyzer with an ncurses interface
    nload                     # Monitors network traffic and bandwidth usage with ncurses graphs
    pciutils                  # Collection of programs for inspecting and manipulating configuration of PCI devices
    progress                  # Tool that shows the progress of coreutils programs
    speedtest-cli             # Command line interface for testing internet bandwidth using speedtest.net
    unzip                     # Extraction utility for archives compressed in .zip format
    # ventoy                    # New Bootable USB Solution
    wget                      # Tool for retrieving files using HTTP, HTTPS, and FTP
    wl-clipboard              # Command-line copy/paste utilities for Wayland
    yt-dlp                    # Command-line tool to download videos from YouTube.com and other sites (youtube-dl fork)
    zip                       # Compressor/archiver for creating and modifying zipfiles
  ];
}
