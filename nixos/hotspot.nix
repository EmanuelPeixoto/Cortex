{lib, config, pkgs, ... }:
{


  services.create_ap = {
    enable = false;
    settings = {
      INTERNET_IFACE = "enp9s0";
      WIFI_IFACE = "wlp12s0";
      SSID = "";
      PASSPHRASE = "";
    };
  };


}
