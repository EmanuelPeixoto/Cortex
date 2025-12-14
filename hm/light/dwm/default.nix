{ config, pkgs, ... }:

let
  fullGapsPatch = pkgs.fetchpatch {
    url = "https://dwm.suckless.org/patches/fullgaps/dwm-fullgaps-6.4.diff";
    sha256 = "sha256-+OXRqnlVeCP2Ihco+J7s5BQPpwFyRRf8lnVsN7rm+Cc=";
  };

  dwmConf = pkgs.writeText "config.h" ''
    #include <X11/XF86keysym.h>

    /* appearance */
    static const unsigned int borderpx  = 2;        /* espessura da borda */
    static const unsigned int gappx     = 10;       /* tamanho do GAP */
    static const unsigned int snap      = 32;       /* snap pixel */
    static const int showbar            = 1;
    static const int topbar             = 0;        /* 0 = Barra em baixo, 1 = Barra em cima */
    static const char *fonts[]          = { "monospace:size=10", "Noto Color Emoji:size=10" };
    static const char dmenufont[]       = "monospace:size=10";

    /* CORES - TEMA OXOCARBON DARK */
    static const char col_bg[]          = "#161616"; /* base00 - Fundo Escuro */
    static const char col_gray2[]       = "#262626"; /* base01 - Borda Inativa */
    static const char col_text[]        = "#dde1e6"; /* base04 - Texto Normal */
    static const char col_text_sel[]    = "#161616"; /* base00 - Texto Selecionado (contraste) */
    static const char col_accent[]      = "#3ddbd9"; /* base0A - Azul (Destaque/Foco) */

    static const char *colors[][3]      = {
        /* fg         bg        border   */
        [SchemeNorm] = { col_text,  col_bg,   col_gray2 },
        [SchemeSel]  = { col_bg,    col_accent, col_accent  },
    };

    /* tagging */
    static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" };

    static const Rule rules[] = {
        /* class      instance    title       tags mask     isfloating   monitor */
        { "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
    };

    /* layout(s) */
    static const float mfact     = 0.55;
    static const int nmaster     = 1;
    static const int resizehints = 0;
    static const int lockfullscreen = 1;

    static const Layout layouts[] = {
        { "[]=",      tile },
        { "><>",      NULL },
        { "[M]",      monocle },
    };

    /* key definitions */
    #define MODKEY Mod4Mask
    #define TAGKEYS(KEY,TAG) \
        { MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
        { MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
        { MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
        { MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

    #define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

    static char dmenumon[2] = "0";
    static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_bg, "-nf", col_text, "-sb", col_accent, "-sf", col_bg, NULL };
    static const char *termcmd[]  = { "kitty", NULL };
    static const char *falkoncmd[] = { "falkon", NULL };

    /* Screenshots */
    static const char *printcmd[] = { "sh", "-c", "maim ~/Pictures/screenshot_$(date +%s).png", NULL };
    static const char *printselcmd[] = { "sh", "-c", "maim -s | xclip -selection clipboard -t image/png", NULL };

    static const Key keys[] = {
        /* modifier                     key              function        argument */
        { MODKEY,                       XK_d,            spawn,          {.v = dmenucmd } },
        { MODKEY,                       XK_Return,       spawn,          {.v = termcmd } },
        { 0,                            XF86HomePage,     spawn,          {.v = falkoncmd } },

        /* RESTART BARRA (Mod + Shift + R) - Usa o PID file */
        { MODKEY|ShiftMask,             XK_r,            spawn,          SHCMD("kill $(cat ~/.cache/pidofbar); sleep 0.5; ~/.local/bin/dwm-status &") },

        /* Print Screen */
        { 0,                            XK_Print,        spawn,          {.v = printcmd } },
        { MODKEY|ShiftMask,             XK_s,            spawn,          {.v = printselcmd } },
        { ShiftMask,                    XK_Print,        spawn,          {.v = printselcmd } },

        /* Controle de Janelas */
        { MODKEY,                       XK_j,            focusstack,     {.i = +1 } },
        { MODKEY,                       XK_k,            focusstack,     {.i = -1 } },
        { MODKEY,                       XK_i,            incnmaster,     {.i = +1 } },
        { MODKEY,                       XK_o,            incnmaster,     {.i = -1 } },
        { MODKEY,                       XK_h,            setmfact,       {.f = -0.05} },
        { MODKEY,                       XK_l,            setmfact,       {.f = +0.05} },
        { MODKEY|ShiftMask,             XK_Return,       zoom,           {0} },
        { MODKEY,                       XK_Tab,          view,           {0} },
        { MODKEY|ShiftMask,             XK_c,            killclient,     {0} },
        { MODKEY|ShiftMask,             XK_q,            killclient,     {0} },

        /* Layouts */
        { MODKEY,                       XK_t,            setlayout,      {.v = &layouts[0]} },
        { MODKEY,                       XK_f,            setlayout,      {.v = &layouts[1]} },
        { MODKEY,                       XK_m,            setlayout,      {.v = &layouts[2]} },
        { MODKEY,                       XK_space,        setlayout,      {0} },
        { MODKEY|ShiftMask,             XK_space,        togglefloating, {0} },

        /* Gaps */
        { MODKEY,                       XK_minus,        setgaps,        {.i = -1 } },
        { MODKEY,                       XK_equal,        setgaps,        {.i = +1 } },
        { MODKEY|ShiftMask,             XK_equal,        setgaps,        {.i = 0  } },

        /* Sistema */
        { MODKEY|ShiftMask,             XK_e,            quit,           {0} },

        /* RESTART BARRA (Mod + Shift + R) */
        { MODKEY|ShiftMask,             XK_r,            spawn,          SHCMD("killall dwm-status; ~/.local/bin/dwm-status &") },


        /* Audio e Brilho (MÉTODO PIPE FIFO - Instantâneo) */
        { 0, XF86XK_AudioMute,          spawn, SHCMD("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle; echo > /tmp/dwm-status-pipe") },
        { 0, XF86XK_AudioLowerVolume,   spawn, SHCMD("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-; echo > /tmp/dwm-status-pipe") },
        { 0, XF86XK_AudioRaiseVolume,   spawn, SHCMD("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.25; echo > /tmp/dwm-status-pipe") },

        /* Controle de Mídia (Playerctl) */
        { 0, XF86XK_AudioPlay,          spawn, SHCMD("playerctl play-pause") },
        { 0, XF86XK_AudioNext,          spawn, SHCMD("playerctl next") },
        { 0, XF86XK_AudioPrev,          spawn, SHCMD("playerctl previous") },
        { 0, XF86XK_AudioStop,          spawn, SHCMD("playerctl stop") },

        /* Brilho */
        { 0, XF86XK_MonBrightnessDown,  spawn, SHCMD("brightnessctl set 5%-; echo > /tmp/dwm-status-pipe") },
        { 0, XF86XK_MonBrightnessUp,    spawn, SHCMD("brightnessctl set 5%+; echo > /tmp/dwm-status-pipe") },

        TAGKEYS(                        XK_1,                      0)
        TAGKEYS(                        XK_2,                      1)
        TAGKEYS(                        XK_3,                      2)
        TAGKEYS(                        XK_4,                      3)
        TAGKEYS(                        XK_5,                      4)
        TAGKEYS(                        XK_6,                      5)
        TAGKEYS(                        XK_7,                      6)
        TAGKEYS(                        XK_8,                      7)
        TAGKEYS(                        XK_9,                      8)
        TAGKEYS(                        XK_0,                      9)
    };

    static const Button buttons[] = {
        { ClkClientWin,     MODKEY,     Button1,    movemouse,      {0} },
        { ClkClientWin,     MODKEY,     Button2,    togglefloating, {0} },
        { ClkClientWin,     MODKEY,     Button3,    resizemouse,    {0} },
        { ClkTagBar,        0,          Button1,    view,           {0} },
        { ClkTagBar,        0,          Button3,    toggleview,     {0} },
        { ClkTagBar,        MODKEY,     Button1,    tag,            {0} },
        { ClkTagBar,        MODKEY,     Button3,    toggletag,      {0} },
    };
  '';
in
{
  nixpkgs.overlays = [
    (final: prev: {
      dwm = prev.dwm.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or []) ++ [ fullGapsPatch ];
        postPatch = "${oldAttrs.postPatch or ""} cp ${dwmConf} config.def.h";
      });
    })
  ];

  home.file.".local/bin/dwm-status" = {
    source = ./dwm.sh;
    executable = true;
  };

  home.packages = with pkgs; [
    brightnessctl
    dmenu
    dwm
    feh
    kitty
    maim
    playerctl
    xclip
    xorg.xsetroot
  ];

  xsession = {
    enable = true;
    windowManager.command = "dwm";
    initExtra = ''
      # Wallpaper
      feh --bg-fill --randomize ${config.home.homeDirectory}/.config/Cortex/hm/note/assets/wallpapers &

      pkill -f "dwm-status" || true

      ~/.local/bin/dwm-status &
    '';
  };
}
