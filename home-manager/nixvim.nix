{ inputs, ... }:
{
  home.packages = [
    inputs.nixvim.packages."x86_64-linux".default
  ];
}
