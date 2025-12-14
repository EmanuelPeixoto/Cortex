{ pkgs, ... }:
let
  catfolder = import ../shared/scripts/catfolder.nix { inherit pkgs; };
  hotspot = import ../note/scripts/hotspot.nix { inherit pkgs; };
  motd = import ../shared/scripts/motd.nix { inherit pkgs; };
  yt-tlp-menu = import ../shared/scripts/yt-dlp-menu.nix { inherit pkgs; };
in
{
  home.packages = with pkgs; [
    catfolder
    hotspot
    motd
    yt-tlp-menu

    gqrx
    audacity                  # Sound editor with graphical UI
    bison                     # Yacc-compatible parser generator
    curl                      # Command line tool for transferring files with URL syntax
    exfatprogs                # exFAT filesystem userspace utilities
    f3                        # Fight Flash Fraud
    ffmpeg                    # Complete, cross-platform solution to record, convert and stream audio and video
    flex                      # Fast lexical analyser generator
    gcc                       # GNU Compiler Collection
    gdb                       # GNU Project debugger
    gemini-cli                # AI agent that brings the power of Gemini directly into your terminal
    gh                        # GitHub CLI tool
    gimp                      # GNU Image Manipulation Program
    glibc                     # GNU C Library
    gnumake                   # Tool to control the generation of non-source files from sources
    gparted                   # Graphical disk partitioning tool
    iftop                     # Display bandwidth usage on a network interface
    inetutils                 # Collection of common network programs
    iw                        # Tool to use nl80211
    jmtpfs                    # FUSE filesystem for MTP devices like Android phones
    killall                   # No description :/
    lazygit                   # Simple terminal UI for git commands
    libmtp                    # Implementation of Microsoft's Media Transfer Protocol
    lm_sensors                # Tools for reading hardware sensors
    lshw                      # Provide detailed information on the hardware configuration of the machine
    metasploit                # Metasploit Framework - a collection of exploits
    mpv                       # General-purpose media player, fork of MPlayer and mplayer2
    ncdu                      # Disk usage analyzer with an ncurses interface
    netcat                    # Free TLS/SSL implementation
    nload                     # Monitors network traffic and bandwidth usage with ncurses graphs
    nmap                      # Free and open source utility for network discovery and security auditing
    nomacs                    # Qt-based image viewer
    pciutils                  # Collection of programs for inspecting and manipulating configuration of PCI devices
    prismlauncher             # Free, open source launcher for Minecraft
    progress                  # Tool that shows the progress of coreutils programs
    qbittorrent               # Featureful free software BitTorrent client
    qemu                      # Generic and open source machine emulator and virtualizer
    speedtest-cli             # Command line interface for testing internet bandwidth using speedtest.net
    stress                    # Simple workload generator for POSIX systems.
    superTuxKart              # Free 3D kart racing game
    telegram-desktop          # Telegram Desktop messaging app
    tor-browser               # Privacy-focused browser routing traffic through the Tor network
    unrar                     # Utility for RAR archives
    unzip                     # Extraction utility for archives compressed in .zip format
    usbutils                  # Tools for working with USB devices, such as lsusb
    vlc                       # Cross-platform media player and streaming server
    wget                      # Tool for retrieving files using HTTP, HTTPS, and FTP
    wine                      # Compatibility layer for running Windows applications
    winetricks                # Helper script to download and install various redistributable runtime libraries
    yt-dlp                    # Command-line tool to download videos from YouTube.com and other sites (youtube-dl fork)
    zathura                   # Highly customizable and functional PDF viewer
    zip                       # Compressor/archiver for creating and modifying zipfiles
  ];
}
