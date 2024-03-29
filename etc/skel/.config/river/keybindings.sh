#!/usr/bin/env bash

# Use the "logo" key as the primary modifier
mod="Mod4"

# Default terminal emulator
term="alacritty"

# Application launcher
launcher="eval rofi -show combi -combi-modi 'drun,run' -terminal $term -ssh-command '{terminal} {ssh-client} {host} [-p {port}]' -run-shell-command '{terminal} {cmd}'"

# Volume changing notify
volume_bar="/usr/share/river/scripts/volume-notify.sh"

# Brightness changing notify
brightness_bar="/usr/share/river/scripts/brightness-notify.sh"

# Screenshot notify
screenshot_notify="eval [[ $(wl-paste -l) == "image/png" ]] && notify-send 'Screenshot copied to clipboard'"

# Screenshot scripts
riverctl map normal "None" Print spawn "/usr/bin/river-grimshot save screen - | swappy -f - && bash -c $screenshot_notify"
riverctl map normal "$mod" Print spawn "/usr/bin/river-grimshot save area - | swappy -f - && bash -c $screenshot_notify"

# Set keyboard layout. See man riverctl
# riverctl keyboard-layout -options "grp:caps_toggle" "us,ru"

# Binding to reload the configuration (good for edits on bindings or adding new stuff
riverctl map normal $mod R spawn $HOME/.config/river/init

# $mod+Shift+Return to start an instance of terminal
riverctl map normal $mod Return spawn $term

# $mod+D to start an instance of application launcher
riverctl map normal $mod D spawn "$launcher"

# $mod+Q to close the focused view
riverctl map normal $mod+Shift Q close

# $mod+Shift+E to run nwg-bar (logout, restart, shutdown, etc)
riverctl map normal $mod+Shift E spawn nwg-bar

# $mod+J and $mod+K to focus the next/previous view in the layout stack
riverctl map normal $mod J focus-view next
riverctl map normal $mod K focus-view previous

# $mod+Shift+J and $mod+Shift+K to swap the focused view with the next/previous
# view in the layout stack
riverctl map normal $mod+Shift J swap next
riverctl map normal $mod+Shift K swap previous

# $mod+Period and $mod+Comma to focus the next/previous output
riverctl map normal $mod Period focus-output next
riverctl map normal $mod Comma focus-output previous

# $mod+Shift+{Period,Comma} to send the focused view to the next/previous output
riverctl map normal $mod+Shift Period send-to-output next
riverctl map normal $mod+Shift Comma send-to-output previous

# $mod+Return to bump the focused view to the top of the layout stack
riverctl map normal $mod+Shift Return zoom

# $mod+H and $mod+L to decrease/increase the main ratio of rivertile(1)
riverctl map normal $mod H send-layout-cmd rivertile "main-ratio -0.05"
riverctl map normal $mod L send-layout-cmd rivertile "main-ratio +0.05"

# $mod+Shift+H and $mod+Shift+L to increment/decrement the main count of rivertile(1)
riverctl map normal $mod+Shift H send-layout-cmd rivertile "main-count +1"
riverctl map normal $mod+Shift L send-layout-cmd rivertile "main-count -1"

# $mod+Alt+{H,J,K,L} to move views
riverctl map normal $mod+Alt H move left 100
riverctl map normal $mod+Alt J move down 100
riverctl map normal $mod+Alt K move up 100
riverctl map normal $mod+Alt L move right 100

# $mod+Alt+Control+{H,J,K,L} to snap views to screen edges
riverctl map normal $mod+Alt+Control H snap left
riverctl map normal $mod+Alt+Control J snap down
riverctl map normal $mod+Alt+Control K snap up
riverctl map normal $mod+Alt+Control L snap right

# $mod+Alt+Shift+{H,J,K,L} to resize views
riverctl map normal $mod+Alt+Shift H resize horizontal -100
riverctl map normal $mod+Alt+Shift J resize vertical 100
riverctl map normal $mod+Alt+Shift K resize vertical -100
riverctl map normal $mod+Alt+Shift L resize horizontal 100

# $mod + Left Mouse Button to move views
riverctl map-pointer normal $mod BTN_LEFT move-view

# $mod + Right Mouse Button to resize views
riverctl map-pointer normal $mod BTN_RIGHT resize-view

# $mod + Middle Mouse Button to toggle float
riverctl map-pointer normal $mod BTN_MIDDLE toggle-float

for i in $(seq 1 9)
do
    tags=$((1 << ($i - 1)))

    # $mod+[1-9] to focus tag [0-8]
    riverctl map normal $mod $i set-focused-tags $tags

    # $mod+Shift+[1-9] to tag focused view with tag [0-8]
    riverctl map normal $mod+Shift $i set-view-tags $tags

    # $mod+Control+[1-9] to toggle focus of tag [0-8]
    riverctl map normal $mod+Control $i toggle-focused-tags $tags

    # $mod+Shift+Control+[1-9] to toggle tag [0-8] of focused view
    riverctl map normal $mod+Shift+Control $i toggle-view-tags $tags
done

# $mod+0 to focus all tags
# $mod+Shift+0 to tag focused view with all tags
all_tags=$(((1 << 32) - 1))
riverctl map normal $mod 0 set-focused-tags $all_tags
riverctl map normal $mod+Shift 0 set-view-tags $all_tags

# $mod+Space to toggle float
riverctl map normal $mod Space toggle-float

# $mod+F to toggle fullscreen
riverctl map normal $mod F toggle-fullscreen

# $mod+{Up,Right,Down,Left} to change layout orientation
riverctl map normal $mod Up    send-layout-cmd rivertile "main-location top"
riverctl map normal $mod Right send-layout-cmd rivertile "main-location right"
riverctl map normal $mod Down  send-layout-cmd rivertile "main-location bottom"
riverctl map normal $mod Left  send-layout-cmd rivertile "main-location left"

# Declare a passthrough mode. This mode has only a single mapping to return to
# normal mode. This makes it useful for testing a nested wayland compositor
riverctl declare-mode passthrough

# $mod+F11 to enter passthrough mode
riverctl map normal $mod F11 enter-mode passthrough

# $mod+F11 to return to normal mode
riverctl map passthrough $mod F11 enter-mode normal

# Various media key mapping examples for both normal and locked mode which do
# not have a modifier
for mode in normal locked
do
    # Eject the optical drive (well if you still have one that is)
    riverctl map $mode None XF86Eject spawn 'eject -T'

    # Control pulse audio volume with pamixer (https://github.com/cdemoulins/pamixer)
    riverctl map $mode None XF86AudioRaiseVolume  spawn "pulsemixer --change-volume +5 && $volume_bar"
    riverctl map $mode None XF86AudioLowerVolume  spawn "pulsemixer --change-volume -5 && $volume_bar"
    riverctl map $mode None XF86AudioMute         spawn "pulsemixer --toggle-mute && $volume_bar"

    # Control MPRIS aware media players with playerctl (https://github.com/altdesktop/playerctl)
    riverctl map $mode None XF86AudioMedia spawn 'playerctl play-pause'
    riverctl map $mode None XF86AudioPlay  spawn 'playerctl play-pause'
    riverctl map $mode None XF86AudioPrev  spawn 'playerctl previous'
    riverctl map $mode None XF86AudioNext  spawn 'playerctl next'

    # Control screen backlight brightness with light (https://github.com/haikarainen/light)
    riverctl map $mode None XF86MonBrightnessUp   spawn "light -A 5 && $brightness_bar"
    riverctl map $mode None XF86MonBrightnessDown spawn "light -U 5 && $brightness_bar"
done

# Set keyboard repeat rate
riverctl set-repeat 50 300

# Make all views with an app-id that starts with "floating_shell" start floating.
riverctl float-filter-add app-id "floating_shell"
# Set floating view for some apps
riverctl float-filter-add app-id "engrampa"
riverctl float-filter-add app-id "nwg-look"
riverctl float-filter-add app-id "qt5ct"
riverctl float-filter-add app-id "qt6ct"
riverctl float-filter-add app-id "pavucontrol"
riverctl float-filter-add title "Picture-in-Picture"
riverctl float-filter-add title "Firefox — Sharing Indicator"
