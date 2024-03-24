{lib, config, pkgs, ... }:
{
  services.create_ap = {
    enable = false;
    settings = {
      INTERNET_IFACE = "enp2s0f2";
      WIFI_IFACE = "wlp1s0";
      SSID = "";
      PASSPHRASE = "";
    };
  };
}
