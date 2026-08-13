{ pkgs, ... }:
{
  home.packages = [ pkgs.satty ];

  xdg.configFile."satty/config.toml".text = ''
    [general]
    output-filename = "~/Pictures/satty-%Y-%m-%d_%H:%M:%S.png"
    floating-hack = true
    early-exit = ["all"]
    resize = { mode = "smart" }
  '';
}
