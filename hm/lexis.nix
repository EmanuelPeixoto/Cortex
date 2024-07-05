{ inputs, ... }:
{
  home.packages = [
    inputs.lexis.packages."x86_64-linux".default
  ];
}
