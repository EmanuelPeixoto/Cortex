{ pkgs, ... }:
{
  users.users.emanuel = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Emanuel Peixoto";
    extraGroups = [ "networkmanager" "wheel" "wireshark" "dialout" ];
  };
}
