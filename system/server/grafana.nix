{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ grafana loki alloy ];

  # Cria os diretórios necessários
  systemd.tmpfiles.rules = [
    "d /var/lib/loki 0755 loki loki - -"
    "d /var/lib/loki/index 0755 loki loki - -"
    "d /var/lib/loki/boltdb-cache 0755 loki loki - -"
    "d /var/lib/loki/chunks 0755 loki loki - -"
    "d /var/lib/loki/compactor 0755 loki loki - -"
    "d /etc/alloy 0755 root root - -"  # Diretório para configuração do Alloy
  ];

  # Define os usuários e grupos do sistema
  users.users.loki = {
    isSystemUser = true;
    group = "loki";
  };
  users.groups.loki = {};

  # Cria o arquivo de configuração do Alloy
  environment.etc."alloy/config.alloy".text = ''
    logging {
      level = "info"
    }

    server {
      http_listen_port = 9080
      http_listen_address = "0.0.0.0"
    }

    loki.source "local" {
      targets = [{
        __address__ = "localhost:3100",
        __path__ = "/var/log/nginx/access.log",
        job = "nginx",
      }]
      forward_to = [loki.write.local.receiver]
    }

    loki.write "local" {
      endpoint {
        url = "http://localhost:3100/loki/api/v1/push"
      }
    }
  '';

  services = {
    grafana = {
      enable = true;
      settings = {
        server = {
          http_port = 3000;
          http_addr = "0.0.0.0";
          root_url = "https://${config.services.nextcloud.hostName}/grafana/";
          serve_from_sub_path = true;
        };
        security.admin_user = "admin";
        security.admin_password = "admin";
      };
    };

    loki = {
      enable = true;
      configuration = {
        auth_enabled = false;
        server.http_listen_port = 3100;
        common.path_prefix = "/var/lib/loki";
        ingester = {
          lifecycler.ring.kvstore.store = "inmemory";
          lifecycler.final_sleep = "0s";
          chunk_idle_period = "5m";
          chunk_retain_period = "30s";
        };
        schema_config.configs = [{
          from = "2020-10-24";
          store = "tsdb";
          object_store = "filesystem";
          schema = "v13";
          index.prefix = "index_";
          index.period = "24h";
        }];
        storage_config = {
          tsdb_shipper = {
            active_index_directory = "/var/lib/loki/index";
            cache_location = "/var/lib/loki/boltdb-cache";
          };
          filesystem.directory = "/var/lib/loki/chunks";
        };
        limits_config = {
          reject_old_samples = true;
          reject_old_samples_max_age = "168h";
          allow_structured_metadata = false;
        };
        compactor.working_directory = "/var/lib/loki/compactor";
      };
    };

    alloy = {
      enable = true;
      configPath = "/etc/alloy/config.alloy";  # Aponta para o arquivo de configuração
    };
  };

  networking.firewall.allowedTCPPorts = [ 3000 3100 9080 ];
}
