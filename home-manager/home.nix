{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "emanuel";
  home.homeDirectory = "/home/emanuel/";

  imports =
    [
      #./nextcloud.nix
      ./terminal.nix
      ./nvim.nix
      ./ngrok.nix
    ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "22.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.sessionVariables = {
  EDITOR = "nvim";
  BROWSER = "brave";
  TERMINAL = "alacritty";
  };

  # Allow unfree packages
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
  home.packages = with pkgs; [
    aircrack-ng
    alacritty
    audacity
    brave
    ccid
    discord
    dmenu
    eww
    firefox
    gimp
    git
    go
    gopls
    htop
    jetbrains.goland
    kate
    mixxx
    modem-manager-gui
    modemmanager
    mpd-mpris
    ncmpcpp
    nginx
    nodejs_20
    obs-studio
    openshot-qt
    pciutils
    polybarFull
    qbittorrent
    telegram-desktop
    thunderbird
    tor
    tor-browser-bundle-bin
    ventoy-full
    vlc
    warsow
    wine

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];


  # Config MPD
  services.mpd = {
    enable = true;
    musicDirectory = "/home/emanuel/Musicas";
    extraConfig = ''
      audio_output {
        type "pulse"
        name "Pulseaudio"
        server "127.0.0.1" # add this line - MPD must connect to the local sound server
      }
    '';

    # Optional:
    network.listenAddress = "any"; # if you want to allow non-localhost connections
  };

  services.mpd-mpris.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/emanuel/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
