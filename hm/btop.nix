{ ... }:
{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "TTY";
      update_ms = 500;
      cpu_single_graph = true;
      show_io_stat = false;
    };
  };
}
