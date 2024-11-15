{
  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  systemd.user.services.nextcloud-client.Install.WantedBy = [
    "hyprland-session.target"
    "gnome-keyring.service"
  ];
}
