{ inputs, pkgs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
    ./note/ghostty.nix
    ./note/hyprland.nix
    ./note/noctalia.nix
    ./note/stylix.nix
    ./server/lexis.nix
    ./shared/zsh.nix
    ./shared/yazi.nix
  ];

  home = {
    username = "scti";
    homeDirectory = "/home/scti";

    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "zen";
      TERMINAL = "ghostty";
    };

    stateVersion = "25.05";

    packages = with pkgs; [
      google-chrome
      poppler-utils
      zathura
      (python313.withPackages (
        ps: with ps; [
          pdf2image
          pillow
        ]
      ))
    ];
  };

  programs.home-manager.enable = true;
}
