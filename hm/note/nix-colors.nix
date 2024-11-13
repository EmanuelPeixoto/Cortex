{ inputs, ... }:
{
  imports = [
    inputs.nix-colors.homeManagerModules.default
  ];

  colorScheme = {
    name = "MyPC";
    author = "Emanuel Peixoto (github.com/EmanuelPeixoto)";
    palette = {
      background = "#181818";
      border = "#000000";
      font = "#FFFFFF";
      idle = "#828282";
      main = "#D60202";
    };
  };
}
