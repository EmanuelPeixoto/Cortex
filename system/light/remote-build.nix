{
  nix = {
    buildMachines = [ {
      hostName = "epeixoto.ddns.net";
      system = "x86_64-linux";
      protocol = "ssh-ng";
      maxJobs = 8;
      speedFactor = 2;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      sshUser = "emanuel";
      sshKey = "/etc/nix/build_key";
      # sudo ssh-keygen -t ed25519 -f /etc/nix/build_key -N ""
      # sudo chown root:root /etc/nix/build_key
      # sudo chmod 600 /etc/nix/build_key
      # sudo cat /etc/nix/build_key.pub | ssh emanuel@epeixoto.ddns.net "cat >> ~/.ssh/authorized_keys"
    }];

    distributedBuilds = true;

    # Opcional, mas recomendado para debug inicial:
    # Isso evita verificar fingerprints SSH estritamente, útil se o IP muda
    extraOptions = ''builders-use-substitutes = true'';
  };
}
