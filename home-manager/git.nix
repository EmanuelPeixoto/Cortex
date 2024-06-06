{ ... }:
{
  programs.git = {
    enable = true;

    userEmail = "peixoto_emanuel@hotmail.com";
    userName = "EmanuelPeixoto";

    extraConfig = {
      github.User = "EmanuelPeixoto";
      init.defaultBranch = "main";
    };
  };
}
