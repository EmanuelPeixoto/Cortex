{
  programs.git = {
    enable = true;

    userEmail = "leunamepeixoto@gmail.com";
    userName = "EmanuelPeixoto";

    extraConfig = {
      github.User = "EmanuelPeixoto";
      init.defaultBranch = "main";
    };

    difftastic = {
      enable = true;
      display = "side-by-side-show-both";
    };
  };
}
