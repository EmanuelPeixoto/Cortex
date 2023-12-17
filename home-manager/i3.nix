# Color shemes for windows
set $text       #ffffff
set $acolor     #dd3333
set $bcolor     #000000
set $ccolor     #4f4f4f
set $dcolor     #ffffff
#                       border          background      text            indicator
client.focused          $acolor         $acolor         $text           $ccolor
client.unfocused        $bcolor         $bcolor         $text           $ccolor
client.focused_inactive $bcolor         $bcolor         $text           $ccolor
client.urgent           $acolor         $bcolor         $text           $ccolor

default_border pixel 1
default_floating_border pixel 1

set $mod Mod4

# Audio bindings
set $refresh_13status killall -SIGUSR1 polybar
bindsym XF86AudioLowerVolume exec --no-startup-id pamixer -d 2 --allow-boost --set-limit 125 && $refresh_i3status
bindsym XF86AudioRaiseVolume exec --no-startup-id pamixer -i 2 --allow-boost --set-limit 125 && $refresh_i3status
bindsym XF86AudioMute exec --no-startup-id pamixer --toggle-mute --allow-boost --set-limit 125 && $refresh_i3status
bindsym Control+XF86AudioLowerVolume exec --no-startup-id playerctl previous && $refresh_i3status
bindsym Control+XF86AudioRaiseVolume exec --no-startup-id playerctl next && $refresh_i3status
bindsym Control+XF86AudioMute exec --no-startup-id playerctl play-pause && $refresh_i3status


# start a terminal
bindsym $mod+Return exec alacritty

# print screen config
bindsym Print exec maim -s -u | xclip -selection clipboard -t image/png -i

exec_always --no-startup-id $HOME/.config/polybar/launch.sh
