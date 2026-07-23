{ inputs, pkgs, ... }:

{
  home.packages = [
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi
  ];

  /*
  # After rebuild, install pi packages manually:

  pi install git:github.com/DietrichGebert/ponytail
  pi install npm:@ferologics/pi-extensions
  pi install git:github.com/codexstar69/bug-hunter
  pi install npm:pi-web-providers
  pi install git:github.com/joelhooks/pi-tools
  pi install git:github.com/tintinweb/pi-gitnexus
  */
}
