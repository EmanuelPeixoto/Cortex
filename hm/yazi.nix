{ ... }:
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      manager.prepend_keymap = [
        {
          on   = "<C-s>"
          run  = 'shell "$SHELL" --block --confirm'
          desc = "Open shell here"
        }
      ];
    };
  };
}
