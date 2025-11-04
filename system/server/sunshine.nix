{ config, pkgs, ... }:
{
  # 1. PERMISSÕES E PACOTES
  # Nós NÃO usamos mais 'services.sunshine.enable'
  users.users."emanuel".extraGroups = [ "input" "video" ];

  environment.systemPackages = [
    pkgs.sunshine # Adicionamos o pacote aqui
    pkgs.wineWowPackages.stable # Manteve o Wine 32-bit
    # pkgs.wine é desnecessário, wineWowPackages já o inclui
  ];

  # 2. CONFIGURAÇÃO DO FIREWALL (Igual)
  networking.firewall.allowedTCPPorts = [
    47984 # Sunshine Web UI (HTTPS)
    47989 # Sunshine Web UI (HTTP)
    47990 # Controle
    48010 # Streaming de Vídeo
  ];
  networking.firewall.allowedUDPPorts = [
    47998 # Descoberta
    47999 # Descoberta
    48000 # Estatísticas
    48002 # Estatísticas
    48010 # Streaming de Áudio
  ];

  # 3. CONFIGURAÇÃO DO XSERVER E NVIDIA (Quase igual)
  services.xserver.enable = true;
  services.xserver.windowManager.icewm.enable = true;
  services.xserver.displayManager.defaultSession = "none+icewm";

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.lightdm.autoLogin.enable = true;
  services.xserver.displayManager.lightdm.autoLogin.user = "emanuel";

  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.config = ''
    Section "ServerLayout"
      Identifier "Layout0"
      Screen 0 "Screen0" 0 0
    EndSection

    Section "Device"
      Identifier "Device0"
      Driver     "nvidia"
      VendorName "NVIDIA Corporation"
      Option     "AllowEmptyInitialConfiguration" "true"
    EndSection

    Section "Screen"
      Identifier "Screen0"
      Device     "Device0"
      Monitor    "Monitor0"
      DefaultDepth 24
      SubSection "Display"
        Depth 24
        Virtual "1920 1080"
      EndSubSection
    EndSection

    Section "Monitor"
      Identifier "Monitor0"
      HorizSync 28.0 - 80.0
      VertRefresh 50.0 - 75.0
    EndSection
  '';

  # 4. A CORREÇÃO MÁGICA (A OPÇÃO CORRETA)
  # Isto inicia o Sunshine DENTRO da sessão 'icewm' do 'emanuel'
services.xserver.windowManager.icewm.startup = ''
    ${pkgs.sunshine}/bin/sunshine &
  '';


}
