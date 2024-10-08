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
        grace = 300;
        hide_cursor = true;
      };

      input-field = {
        size = "200, 50";
        dots_center = true;
        fade_on_empty = true;
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
        font_color = "rgba(ffffffff)";
        inner_color = "rgba(000000ff)";
        outer_color = "rgba(d60202ff)";
        outline_thickness = 2;
        placeholder_text = "Insira a senha";
      };

      label = [
        {
          position = "0, 250";
          halign = "center";
          valign = "center";
          text = "$TIME";
          color = "rgba(ffffffff)";
          font_size = 25;
        }
      ];

      shape = [
        {
          size = "200, 50";
          border_color = "rgba(d60202ff)";
          border_size = 2;
          color = "rgba(000000ff)";
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
