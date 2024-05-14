{ config, ... }:
{
  programs.htop.enable = true;
  programs.htop.settings = {
    show_cpu_frequency = true;
    show_cpu_temperature = true;
    show_program_path = false;
    screen_tabs = true;
    delay = 5;
    fields = with config.lib.htop.fields; [
      PID
      USER
      #PRIORITY
      #NICE
      M_SIZE
      #M_RESIDENT
      #M_SHARE
      #STATE
      PERCENT_CPU
      PERCENT_MEM
      TIME
      COMM
    ];
  } // (with config.lib.htop; leftMeters [
    (bar "AllCPUs")
    (bar "Memory")
  ]) // (with config.lib.htop; rightMeters [
    (text "Uptime")
    (text "Battery")
    (text "Systemd")
    (bar "Swap")
  ]);
}
