{lib, config, pkgs, ... }:
let
  text = "#ffffff";
  acolor = "#dd3333";
  bcolor = "#000000";
  ccolor = "#4f4f4f";
  dcolor = "#ffffff";
  mod = "Mod4";

in {
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = mod;
      defaultWorkspace = "workspace number 1";
      terminal = "alacritty";

      startup = [
        {command = "systemctl --user restart polybar"; always = true; notification = false;}
      ];
      window = {
        border = 1;
        titlebar = false;
        hideEdgeBorders = "smart";
      };
      floating = {
        titlebar = false;
        border = 1;
      };

      colors = {
        focused = {
          border = acolor;
          background = acolor;
          text = text;
          indicator = ccolor;
          childBorder = acolor;
        };
        unfocused = {
          border = bcolor;
          background = bcolor;
          text = text;
          indicator = ccolor;
          childBorder = acolor;
        };
        focusedInactive = {
          border = bcolor;
          background = bcolor;
          text = text;
          indicator = ccolor;
          childBorder = acolor;
        };
        urgent = {
          border = acolor;
          background = bcolor;
          text = text;
          indicator = ccolor;
          childBorder = acolor;
        };
        placeholder = {
          border = bcolor;
          background = bcolor;
          text = text;
          indicator = ccolor;
          childBorder = acolor;
        };
        background = bcolor;
      };

      keybindings = {
        # Audio
        "XF86AudioLowerVolume" = "exec --no-startup-id pamixer -d 2 --allow-boost --set-limit 125";
        "XF86AudioRaiseVolume" = "exec --no-startup-id pamixer -i 2 --allow-boost --set-limit 125";
        "XF86AudioMute" = "exec --no-startup-id pamixer --toggle-mute --allow-boost --set-limit 125";
        "Control+XF86AudioLowerVolume" = "exec --no-startup-id playerctl previous";
        "Control+XF86AudioRaiseVolume" = "exec --no-startup-id playerctl next";
        "Control+XF86AudioMute" = "exec --no-startup-id playerctl play-pause";

        # Terminal
        "${mod}+Return" = "exec alacritty";

        # Print screen
        "Print" = "exec maim -s -u | xclip -selection clipboard -t image/png -i";

        # kill focused window
        "${mod}+Shift+q" = "split toggle kill";

        # start dmenu (a program launcher)
        "${mod}+d" = "exec --no-startup-id dmenu_run";

        # change focus
        "${mod}+j" = "focus left";
        "${mod}+k" = "focus down";
        "${mod}+l" = "focus up";
        "${mod}+ccedilla" = "focus right";

        # alternatively, you can use the cursor keys:
        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";

        # move focused window
        "${mod}+Shift+j" = "move left";
        "${mod}+Shift+k" = "move down";
        "${mod}+Shift+l" = "move up";
        "${mod}+Shift+ccedilla" = "move right";

        # alternatively, you can use the cursor keys:
        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Right" = "move right";

        # split in horizontal orientation
        "${mod}+h" = "split h";

        # split in vertical orientation
        "${mod}+v" = "split v";

        # enter fullscreen mode for the focused container
        "${mod}+f" = "fullscreen toggle";

        # change container layout (stacked, tabbed, toggle split)
        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";

        # toggle tiling / floating
        "${mod}+Shift+space" = "floating toggle";

        # change focus between tiling / floating windows
        "${mod}+space" = "focus mode_toggle";

        # focus the parent container
        "${mod}+a" = "focus parent";

        # focus the child container
        #"${mod}+d" = "focus child";

        # switch to workspace
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        "${mod}+0" = "workspace number 10";

        # move focused container to workspace
        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+0" = "move container to workspace number 10";

        # reload the configuration file
        "${mod}+Shift+c" = "reload";

       # restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
       "${mod}+Shift+r" = "restart";

        # exit i3 (logs you out of your X session)
        "${mod}+Shift+e" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";

        # resize window (you can also use the mouse for that)
        "${mod}+r" = "mode resize";
      };

      modes = {
        resize = {
          # These bindings trigger as soon as you enter the resize mode

          # Pressing left will shrink the window’s width.
          # Pressing right will grow the window’s width.
          # Pressing up will shrink the window’s height.
          # Pressing down will grow the window’s height.
          "j" = "resize shrink width 10 px or 10 ppt";
          "k" = "resize grow height 10 px or 10 ppt";
          "l" = "resize shrink height 10 px or 10 ppt";
          "ccedilla" = "resize grow width 10 px or 10 ppt";

          # same bindings, but for the arrow keys
          "Left" = "resize shrink width 10 px or 10 ppt";
          "Down" = "resize grow height 10 px or 10 ppt";
          "Up" = "resize shrink height 10 px or 10 ppt";
          "Right" = "resize grow width 10 px or 10 ppt";

          # back to normal: Enter or Escape or $mod+r
          "Return" = "mode default";
          "Escape" = "mode default";
          "$mod+r" = "mode default";
        };
      };
      bars = [];
    };
    extraConfig = ''
      default_orientation vertical
      for_window [class=".*"] split toggle
    '';
  };
}
