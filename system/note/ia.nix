{ inputs, pkgs, ... }:
{
  # services.ollama = {
  #   enable = true;
  #   package = pkgs.ollama-cuda;
  #   loadModels = [ "" ];
  # };

  environment.systemPackages = with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
    pi
  ];
}
