{ config, ... }:
{
  programs.hyprlock = {
    enable = true;
    settings = {
      background = {
        blur_passes = 3;
        blur_size = 1;
        path = "screenshot";
      };

      general = {
        disable_loading_bar = true;
        grace = 30;
        hide_cursor = true;
      };

      input-field = {
        size = "200, 50";
        dots_center = true;
        fade_on_empty = true;
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
        font_color = "rgb(${config.colorScheme.palette.font})";
        inner_color = "rgb(${config.colorScheme.palette.border})";
        outer_color = "rgb(${config.colorScheme.palette.main})";
        outline_thickness = 2;
        placeholder_text = "Insira a senha";
      };

      label = [
        {
          position = "0, 250";
          halign = "center";
          valign = "center";
          text = "$TIME";
          color = "rgb(${config.colorScheme.palette.font})";
          font_size = 25;
        }
      ];

      shape = [
        {
          size = "200, 50";
          border_color = "rgb(${config.colorScheme.palette.main})";
          border_size = 2;
          color = "rgb(${config.colorScheme.palette.border})";
          halign = "center";
          position = "0, 250";
          rotate = 0;
          rounding = -1;
          valign = "center";
          xray = false;
        }
      ];
    };
  };
}
