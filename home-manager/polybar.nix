{lib, config, pkgs, ... }:
{


services.polybar.config = {

[colors]
background = #282A2E
background-alt = #373B41
foreground = #C5C8C6
primary = #F0C674
secondary = #8ABEB7
alert = #A54242
disabled = #707880

[bar/barra]
width = 100%
height = 16pt
radius = 0
bottom = true
tray-position = right

dpi = 96

background = ${colors.background}
foreground = ${colors.foreground}

line-size = 3pt

border-size = 0pt
border-color = #00000000

padding-left = 0
padding-right = 0

module-margin = 0

separator = |
separator-foreground = ${colors.disabled}

font-0 = monospace:size=10;2

modules-left = xworkspaces
modules-right = xkeyboard filesystem wlan eth battery memory cpu pulseaudio date

cursor-click = pointer
cursor-scroll = ns-resize

enable-ipc = true

[module/xworkspaces]
type = internal/xworkspaces
label-active = %name%
label-active-background = ${colors.background-alt}
label-active-underline= ${colors.primary}
label-active-padding = 1
label-occupied = %name%
label-occupied-padding = 1
label-urgent = %name%
label-urgent-background = ${colors.alert}
label-urgent-padding = 1
label-empty = %name%
label-empty-foreground = ${colors.disabled}
label-empty-padding = 1


[module/xkeyboard]
type = internal/xkeyboard
label-layout = ""
format-spacing = 1
label-indicator-on-capslock = Caps
label-indicator-on-numlock = Num
label-indicator-on-scrolllock = Scroll


[module/filesystem]
type = internal/fs
interval = 25
mount-0 = /
label-mounted = %{F#F0C674}%mountpoint%%{F-} %percentage_used%%
label-unmounted = %mountpoint% not mounted
label-unmounted-foreground = ${colors.disabled}


[network-base]
type = internal/network
interval = 5
format-connected = <label-connected>
format-disconnected = <label-disconnected>


[module/wlan]
inherit = network-base
interface-type = wireless
label-connected = %{A1:alacritty -e nmtui:}%{F#F0C674}%signal%% W:%{F-} %essid%%{A}


[module/eth]
inherit = network-base
interface = enp2s0f2
interface-type = wired
label-connected = %{F#F0C674}E:%{F-} %local_ip%


[module/memory]
type = internal/memory
interval = 2
format-prefix = %{A1:alacritty -e htop --sort-key=PERCENT_MEM:}Ram:%{A}
format-prefix-foreground = ${colors.primary}
label = %{A1:alacritty -e htop --sort-key=PERCENT_MEM:}%percentage_used:2%%%{A}


[module/cpu]
type = internal/cpu
interval = 2
format-prefix = %{A1:alacritty -e htop --sort-key=PERCENT_CPU:}CPU:%{A}
format-prefix-foreground = ${colors.primary}
label = %{A1:alacritty -e htop --sort-key=PERCENT_CPU:}%percentage:2%%%{A}


[module/pulseaudio]
type = internal/pulseaudio
format-volume-prefix = "Vol: "
format-volume-prefix-foreground = ${colors.primary}
label-muted-foreground = ${colors.disabled}
sink = alsa_output.pci-0000_00_1b.0.analog-stereo
format-volume = <label-volume>
format-muted = <label-muted>
label-volume = %percentage%%
label-muted = muted
click-right = pavucontrol


[module/date]
type = internal/date
interval = 1
date = %{A1:alacritty -e zsh -c 'cal -y && echo "Aperte Enter para sair..." && read':}%d/%m/%Y %H:%M%{A}
label = %date%
label-foreground = ${colors.primary}


[module/battery]
type = internal/battery
full-at = 100
low-at = 10
battery = BAT0
adapter = ADP1
format-charging = <label-charging>
format-discharging = <label-discharging>
format-full = <label-full>
label-charging = Carregando: %percentage%%
label-discharging = Bateria: %percentage%%
label-full = Cheia
poll-interval = 5



[settings]
screenchange-reload = true
pseudo-transparency = true
};


}
