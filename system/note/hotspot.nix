{ ... }:
{
  services.create_ap = {
    enable = false;
    settings = {
      INTERNET_IFACE = "";
      WIFI_IFACE = "wlp1s0";
      SSID = "";
      PASSPHRASE = "";
    };
  };
}
