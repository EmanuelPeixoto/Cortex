{
  services.power-profiles-daemon.enable = false;
  services.xserver = {
    enable = true;

    xkb = {
      layout = "br";
      variant = "";
      model = "";
    };

    desktopManager.cinnamon.enable = true;
  };
}
