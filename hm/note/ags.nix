{ config, inputs, lib, pkgs, ... }:
let
  colors = config.colorScheme.palette;

  generateScss = ''
    // Colors generated from nix-colors
    $bg: #${colors.background};
    $border: #${colors.border};
    $text: #${colors.font};
    $main: #${colors.main};
  '';

  ags = inputs.ags.packages.${pkgs.system};
  deps = [
    ags.battery
    ags.hyprland
    ags.mpris
    ags.network
    ags.tray
    ags.wireplumber
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
    extraPackages = deps ++ [
      pkgs.pwvucontrol
    ];
  };

  home.file."${config.home.homeDirectory}/.config/Cortex/hm/note/ags/Bar/Variables.scss".text = generateScss;

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
