{ pkgs, ... }:
{
  home.packages = with pkgs; [
    aircrack-ng               # Wireless encryption cracking tools
    android-tools             # Android SDK platform tools
    arduino-ide               # Open-source electronics prototyping platform
    audacity                  # Sound editor with graphical UI
    blender                   # 3D Creation/Animation/Publishing System
    curl                      # Command line tool for transferring files with URL syntax
    discord                   # All-in-one cross-platform voice and text chat for gamers
    exfatprogs                # exFAT filesystem userspace utilities
    f3                        # Fight Flash Fraud
    ffmpeg                    # Complete, cross-platform solution to record, convert and stream audio and video
    gcc                       # GNU Compiler Collection
    gdb                       # GNU Project debugger
    gh                        # GitHub CLI tool
    gimp                      # GNU Image Manipulation Program
    glibc                     # GNU C Library
    gnumake                   # Tool to control the generation of non-source files from sources
    gparted                   # Graphical disk partitioning tool
    iftop                     # Display bandwidth usage on a network interface
    jmtpfs                    # FUSE filesystem for MTP devices like Android phones
    killall                   # No description :/
    lazygit                   # Simple terminal UI for git commands
    libmtp                    # Implementation of Microsoft's Media Transfer Protocol
    libreoffice               # Comprehensive, professional-quality productivity suite, a variant of openoffice.org
    lm_sensors                # Tools for reading hardware sensors
    lshw                      # Provide detailed information on the hardware configuration of the machine
    mpv                       # General-purpose media player, fork of MPlayer and mplayer2
    ncdu                      # Disk usage analyzer with an ncurses interface
    netcat                    # Free TLS/SSL implementation
    nload                     # Monitors network traffic and bandwidth usage with ncurses graphs
    nmap                      # Free and open source utility for network discovery and security auditing
    nomacs                    # Qt-based image viewer
    openshot-qt               # Free, open-source video editor
    pciutils                  # Collection of programs for inspecting and manipulating configuration of PCI devices
    prismlauncher             # Free, open source launcher for Minecraft
    progress                  # Tool that shows the progress of coreutils programs
    qbittorrent               # Featureful free software BitTorrent client
    speedtest-cli             # Command line interface for testing internet bandwidth using speedtest.net
    stress                    # Simple workload generator for POSIX systems.
    superTuxKart              # Free 3D kart racing game
    telegram-desktop          # Telegram Desktop messaging app
    texliveFull               # TeX Live environment
    thunderbird               # Full-featured e-mail client
    tor                       # Anonymizing overlay network
    tor-browser               # Privacy-focused browser routing traffic through the Tor network
    unrar                     # Utility for RAR archives
    unzip                     # Extraction utility for archives compressed in .zip format
    usbutils                  # Tools for working with USB devices, such as lsusb
    # ventoy                    # New Bootable USB Solution
    vlc                       # Cross-platform media player and streaming server
    wget                      # Tool for retrieving files using HTTP, HTTPS, and FTP
    wl-clipboard              # Command-line copy/paste utilities for Wayland
    yt-dlp                    # Command-line tool to download videos from YouTube.com and other sites (youtube-dl fork)
    zathura                   # Highly customizable and functional PDF viewer
    zip                       # Compressor/archiver for creating and modifying zipfiles
  ];
}
