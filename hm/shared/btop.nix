{ pkgs, ... }:
{
  programs.btop = {
    enable = true;
    package = pkgs.btop-cuda;
    settings = {
      update_ms = 500;
      cpu_single_graph = true;
      show_io_stat = false;
    };
  };
}
