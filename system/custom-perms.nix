{ pkgs, ... }:
{
  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [
        {
          command = "${pkgs.pmutils}/pm-hibernate";
          options = [ "NOPASSWD" ];
        }
      ];
    }];
  };
}
