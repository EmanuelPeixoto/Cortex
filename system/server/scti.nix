{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nodejs_22
  ];

  programs.fish.enable = true;

  users = {
    users = {
      scti = {
        # Set fish to default shell
        shell = pkgs.fish;
        isNormalUser = true;
        description = "SCTI";
        extraGroups = [ "docker" "wheel" ];
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "peixoto_emanuel@hotmail.com";
    defaults.webroot = "/var/lib/acme/acme-challenge";
    certs."sctiuenf.com.br" = {
      email = "leunamepeixoto@gmail.com";
      group = "www";
    };
  };

  services.nginx = {
    virtualHosts = {
      "SCTI" = {
        serverName = "sctiuenf.com.br";
        listen = [{
          addr = "0.0.0.0";
          port = 443;
          ssl = true;
        }];

        enableACME = true;
        forceSSL = true;

        root = "/notfound";

        extraConfig = ''
        access_log off;
        autoindex off;
        autoindex_exact_size off;
        autoindex_localtime on;
        allow all;
        '';
        locations."/".extraConfig = ''proxy_pass http://127.0.0.1:3000;'';
        locations."/api".extraConfig = ''proxy_pass http://127.0.0.1:8080;'';
      };

      "acme-scti" = {
        serverName = "sctiuenf.com.br";
        listen = [{
          addr = "0.0.0.0";
          port = 80;
        }];

        root = "/var/lib/acme/acme-challenge/";

        locations."/".index = "index.html";
      };
    };
  };

  systemd.services.scti-backend = {
    enable = true;
    description = "SCTI Backend (Docker Compose)";
    serviceConfig = {
      ExecStart = ''${pkgs.docker-compose}/bin/docker-compose up'';
      WorkingDirectory = "/SCTI/SCTI-2025-Backend/src";
      User = "scti";
      Group = "users";
      Restart = "on-failure";
      RestartSec = "5s";
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.scti-frontend = {
    enable = true;
    description = "SCTI Frontend (npm run dev)";
    serviceConfig = {
      Environment = "PATH=/run/current-system/sw/bin:/run/current-system/sw/sbin:/home/scti/.nix-profile/bin";
      ExecStart = ''${pkgs.nodejs}/bin/npm run dev'';
      WorkingDirectory = "/SCTI/SCTI-2025-Frontend";
      User = "scti";
      Group = "users";
      Restart = "on-failure";
      RestartSec = "5s";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
