{ config, inputs, lib, pkgs, ... }:
let
  colors = config.lib.stylix.colors;

  generateScss = ''
    // Colors generated from stylix
    $bg: #${colors.base00};
    $border: #${colors.base02};
    $text: #${colors.base05};
    $main: #${colors.base0D};
  '';

  ags = inputs.ags.packages.${pkgs.system};
  deps = [
    ags.battery
    ags.hyprland
    ags.mpris
    ags.network
    ags.tray
    ags.wireplumber
    pkgs.pwvucontrol
  ];
in
  {
  imports = [ inputs.ags.homeManagerModules.default ];


  programs.ags = {
    enable = true;
    configDir = ./ags;
    package = ags.agsFull.overrideAttrs {
      postFixup = ''wrapProgram $out/bin/ags --prefix PATH : ${lib.makeBinPath deps}'';
    };
  };

  home.file."${config.home.homeDirectory}/.config/ags_variables.scss".text = generateScss;

  systemd.user.services.ags-bar = {
    Unit = {
      Description = "AGS Bar";
      PartOf = [ "hyprland-session.target" ];
      After = [ "hyprland-session.target" ];
    };

    Service =
      let
        ags = "${config.programs.ags.package}/bin/ags";
      in
        {
        ExecStart = "${ags} run";
        ExecReload = "${ags} quit && ${ags} run";
        Restart = "on-failure";
        KillMode = "mixed";
      };

    Install.WantedBy = [ "hyprland-session.target" ];
  };
}
