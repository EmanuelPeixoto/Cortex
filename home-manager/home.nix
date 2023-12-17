{lib, config, pkgs, ... }:

{
  home.username = "emanuel";
  home.homeDirectory = "/home/emanuel/";

  imports =
    [
      ./apps.nix
      ./i3.nix
      ./nextcloud.nix
      ./nvim.nix
      ./polybar/polybar.nix
      ./terminal.nix
    ];

  home.stateVersion = "22.11";

  home.sessionVariables = {
  EDITOR = "nvim";
  BROWSER = "firefox";
  TERMINAL = "alacritty";
  };


  # Config MPD
  services.mpd = {
    enable = true;
    musicDirectory = "/home/emanuel/Musicas";
    network.listenAddress = "any";
    extraConfig = ''
      audio_output {
        type "pulse"
        name "Pulseaudio"
        server "127.0.0.1" # add this line - MPD must connect to the local sound server
      }
    '';
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
