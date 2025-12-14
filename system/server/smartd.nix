{
  services.smartd = {
    enable = true;
    autodetect = true;
    notifications.wall.enable = true;

    defaults.monitored = "-a -o on -s (S/../.././02|L/../../6/03)";
  };
}
