{ inputs, ... }:
{
  home.packages = [
    inputs.zen-browser.packages."x86_64-linux".default
  ];
}
