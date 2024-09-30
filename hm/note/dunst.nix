{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        indicate_hidden = "yes";
        stack_duplicates = true;
        hide_duplicate_count = false;

        title = "Dunst";
        class = "Dunst";

        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = "no";
        show_indicators = "no";
        sticky_history = "no";
        history_length = 20;

        always_run_script = true;
        ignore_dbusclose = false;
        force_xinerama = false;

        # Notification
        sort = "yes";
        scale = 0;
        shrink = "no";
        word_wrap = "yes";

        # Geometry
        width = 350;
        height = 200;
        origin = "bottom-right";
        offset = "12+24";

        padding = 5;
        horizontal_padding = 10;
        notification_limit = 0;
        separator_height = 2;

        # Progress-Bar
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;

        # Aesthetics
        frame_width = 2;
        separator_color = "frame";
        transparency = 30;
        corner_radius = 10;
        highlight = "#ffffff";
        background = "#181818";
        frame_color = "#d60606";
        foreground = "#ffffff";

        line_height = 1;
        idle_threshold = 120;
        markup = "full";
        format = "<span font='8' weight='bold'>%s</span>\\n%b";
        alignment = "left";
        vertical_alignment = "center";

        icon_position = "left";
        min_icon_size = 0;
        max_icon_size = 64;

        # Keybindings
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };

      experimental = { per_monitor_dpi = true; };
    };
  };
}
