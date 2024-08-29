{ ... }:
{
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.emanuel.enableGnomeKeyring = true;
}
