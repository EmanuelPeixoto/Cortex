{
  programs.git = {
    enable = true;

    settings = {
      github.User = "EmanuelPeixoto";
      init.defaultBranch = "main";
      user = {
        email = "leunamepeixoto@gmail.com";
        name = "EmanuelPeixoto";
      };
    };
  };

  programs.difftastic = {
    enable = true;
    git.enable = true;
    options.display = "side-by-side-show-both";
  };
}
