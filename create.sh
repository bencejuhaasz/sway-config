#!/bin/bash

#Bubblejail profile
profile=$(cat <<EOF
[common]
dbus_name = "org.mozilla.*"
executable_name = [
    "sway_noscr_nvidia",
]
filter_disk_sync = false
share_local_time = true

[wayland]

[network]

[pulse_audio]

[direct_rendering]
enable_aco = false

[root_share]
read_only_paths = [
    "/etc",
]
paths = [
    "/sys",
]
EOF
)

home=".local/share/bubblejail/instances/$1/home"
svdir=".local/share/bubblejail/instances/$1"
metadata="creation_profile_name = \"generic\""


mkdir -p ~/$home
echo $profile > ~/$svdir/services.toml
echo $metadata > ~/$svdir/metadata_v1.toml

#zshrc
echo "export HOST=$1" > ~/$home/.zshrc

#termite
tconf=$(cat <<EOF
[options]
font = Source Code Pro 14
[colors]
background = rgba(0, 0, 0, 0.8)
EOF
)

mkdir -p ~/$home/.config/termite
echo $tconf > ~/$home/.config/termite/config

#sway
mkdir -p ~/$home/.config/sway
swaycfg=$(cat <<EOF
# clipbd
bindsym Mod1+Control+c exec wl_copy
bindsym Mod1+Control+v exec wl_paste




input * {
    xkb_layout "hu"
    xkb_variant "colemak,,typewriter"
    xkb_options "grp:win_space_toggle"
}

input type:touchpad {
    tap enabled
    natural_scroll enabled
}



#audio
bindsym XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +5%
bindsym XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -5%
bindsym XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle
bindsym XF86AudioMicMute exec pactl set-source-mute @DEFAULT_SOURCE@ toggle
bindsym XF86MonBrightnessDown exec brightnessctl set 5%-
bindsym XF86MonBrightnessUp exec brightnessctl set +5%
bindsym XF86AudioPlay exec playerctl play-pause
bindsym XF86AudioNext exec playerctl next
bindsym XF86AudioPrev exec playerctl previous
bindsym XF86Search exec bemenu-run

# set floating mode for specific applications
for_window [instance="lxappearance"] floating enable
for_window [title="Graphics"] floating enable
for_window [app_id="pamac-manager"] floating enable
for_window [app_id="blueberry.py"] floating enable
for_window [title="File Operation Progress"] floating enable, border pixel 1, sticky enable, resize set width 40 ppt height 30 ppt
for_window [app_id="firefox" title="Library"] floating enable, border pixel 1, sticky enable
for_window [app_id="thunderbird" title=".*Reminder"] floating enable
for_window [app_id="floating_shell_portrait"] floating enable, border pixel 1, sticky enable, resize set width 30 ppt height 40 ppt
for_window [app_id="floating_shell"] floating enable, border pixel 1, sticky enable
for_window [app_id="Manjaro.manjaro-settings-manager"] floating enable
for_window [title="Picture in picture"] floating enable, sticky enable
for_window [title="nmtui"] floating enable
for_window [app_id="xsensors"] floating enable
for_window [title="Save File"] floating enable
for_window [title="Firefox — Sharing Indicator"] floating enable
for_window [title=".* is sharing your screen."] floating enable
for_window [app_id="wdisplays"] floating enable

# inhibit idle
for_window [app_id="firefox"] inhibit_idle fullscreen
for_window [app_id="Chromium"] inhibit_idle fullscreen
for_window [app_id="firefoxdeveloperedition"] inhibit_idle fullscreen





set $gnome-schema org.gnome.desktop.interface

exec_always {
    gsettings set $gnome-schema gtk-theme 'Arc-Dark'
    gsettings set $gnome-schema icon-theme 'Papirus-Dark'
}
input <identifier> xkb_model "pc101"
# Default config for sway
#
# Copy this to ~/.config/sway/config and edit it to your liking.
#
# Read `man 5 sway` for a complete reference.
font "Source Code Pro 14"
### Variables
#
# Logo key. Use Mod1 for Alt.
set $mod Mod1
# Home row direction keys, like vim
set $left h
set $down j
set $up k
set $right l
# Your preferred terminal emulator
set $theme /usr/share/sway/themes/matcha-green
set $term termite --config=$theme/termite
set $term_float_portrait $term --name=floating_shell_portrait --exec
set $term_float $term --name=floating_shell --exec

# Your preferred application launcher
# Note: pass the final command to swaymsg so that the resulting window can be opened
# on the original workspace that the command was run on.
#set $menu wofi --show run
for_window [app_id="^launcher$"] floating enable, sticky enable, resize set 30 ppt 60 ppt, border pixel 10
set $menu exec $term_float --class=launcher -e /home/user/sway-launcher-desktop/sway-launcher-desktop.sh
### Output configuration
#
# Default wallpaper (more resolutions are available in /usr/share/backgrounds/sway/)
output * bg /usr/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png fill
#
# Example configuration:
#
#   output HDMI-A-1 resolution 1920x1080 position 1920,0
#
# You can get the names of your outputs by running: swaymsg -t get_outputs

### Idle configuration
#
# Example configuration:
#
# exec swayidle -w \
#          timeout 300 'swaylock -f -c 000000' \
#          timeout 600 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' \
#          before-sleep 'swaylock -f -c 000000'
#
# This will lock your screen after 300 seconds of inactivity, then turn off
# your displays after another 300 seconds, and turn your screens back on when
# resumed. It will also lock your screen before your computer goes to sleep.

### Input configuration
#
# Example configuration:
#
#   input "2:14:SynPS/2_Synaptics_TouchPad" {
#       dwt enabled
#       tap enabled
#       natural_scroll enabled
#       middle_emulation enabled
#   }
#
# You can get the names of your inputs by running: swaymsg -t get_inputs
# Read `man 5 sway-input` for more information about this section.

### Key bindings
#
# Basics:
#
    # Start a terminal
    bindsym $mod+Return exec $term

    # Kill focused window
    bindsym $mod+Shift+q kill

    # Start your launcher
    bindsym $mod+d exec $menu

    # Drag floating windows by holding down $mod and left mouse button.
    # Resize them with right mouse button + $mod.
    # Despite the name, also works for non-floating windows.
    # Change normal to inverse to use left mouse button for resizing and right
    # mouse button for dragging.
    floating_modifier $mod normal

    # Reload the configuration file
    bindsym $mod+Shift+c reload

    # Exit sway (logs you out of your Wayland session)
    #bindsym $mod+Shift+e exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'
    bindsym $mod+Shift+e exec wlogout
#
# Moving around:
#
    # Move your focus around
    bindsym $mod+$left focus left
    bindsym $mod+$down focus down
    bindsym $mod+$up focus up
    bindsym $mod+$right focus right
    # Or use $mod+[up|down|left|right]
    bindsym $mod+Left focus left
    bindsym $mod+Down focus down
    bindsym $mod+Up focus up
    bindsym $mod+Right focus right

    # Move the focused window with the same, but add Shift
    bindsym $mod+Shift+$left move left
    bindsym $mod+Shift+$down move down
    bindsym $mod+Shift+$up move up
    bindsym $mod+Shift+$right move right
    # Ditto, with arrow keys
    bindsym $mod+Shift+Left move left
    bindsym $mod+Shift+Down move down
    bindsym $mod+Shift+Up move up
    bindsym $mod+Shift+Right move right
#
# Workspaces:
#
    # Switch to workspace
    bindsym $mod+1 workspace number 1
    bindsym $mod+2 workspace number 2
    bindsym $mod+3 workspace number 3
    bindsym $mod+4 workspace number 4
    bindsym $mod+5 workspace number 5
    bindsym $mod+6 workspace number 6
    bindsym $mod+7 workspace number 7
    bindsym $mod+8 workspace number 8
    bindsym $mod+9 workspace number 9
    bindsym $mod+0 workspace number 10
    # Move focused container to workspace
    bindsym $mod+Shift+1 move container to workspace number 1
    bindsym $mod+Shift+2 move container to workspace number 2
    bindsym $mod+Shift+3 move container to workspace number 3
    bindsym $mod+Shift+4 move container to workspace number 4
    bindsym $mod+Shift+5 move container to workspace number 5
    bindsym $mod+Shift+6 move container to workspace number 6
    bindsym $mod+Shift+7 move container to workspace number 7
    bindsym $mod+Shift+8 move container to workspace number 8
    bindsym $mod+Shift+9 move container to workspace number 9
    bindsym $mod+Shift+0 move container to workspace number 10
    # Note: workspaces can have any name you want, not just numbers.
    # We just use 1-10 as the default.
#
# Layout stuff:
#
    # You can "split" the current object of your focus with
    # $mod+b or $mod+v, for horizontal and vertical splits
    # respectively.
    bindsym $mod+b splith
    bindsym $mod+v splitv

    # Switch the current container between different layout styles
    bindsym $mod+s layout stacking
    bindsym $mod+w layout tabbed
    bindsym $mod+e layout toggle split

    # Make the current focus fullscreen
    bindsym $mod+f fullscreen

    # Toggle the current focus between tiling and floating mode
    bindsym $mod+Shift+space floating toggle

    # Swap focus between the tiling area and the floating area
    bindsym $mod+space focus mode_toggle

    # Move focus to the parent container
    bindsym $mod+a focus parent
#
# Scratchpad:
#
    # Sway has a "scratchpad", which is a bag of holding for windows.
    # You can send windows there and get them back later.

    # Move the currently focused window to the scratchpad
    bindsym $mod+Shift+minus move scratchpad

    # Show the next scratchpad window or hide the focused scratchpad window.
    # If there are multiple scratchpad windows, this command cycles through them.
    bindsym $mod+minus scratchpad show
#
# Resizing containers:
#
mode "resize" {
    # left will shrink the containers width
    # right will grow the containers width
    # up will shrink the containers height
    # down will grow the containers height
    bindsym $left resize shrink width 10px
    bindsym $down resize grow height 10px
    bindsym $up resize shrink height 10px
    bindsym $right resize grow width 10px

    # Ditto, with arrow keys
    bindsym Left resize shrink width 10px
    bindsym Down resize grow height 10px
    bindsym Up resize shrink height 10px
    bindsym Right resize grow width 10px

    # Return to default mode
    bindsym Return mode "default"
    bindsym Escape mode "default"
}
bindsym $mod+r mode "resize"

#
# Status Bar:
#
# Read `man 5 sway-bar` for more information about this section.
bar {
	swaybar_command waybar
}

include /etc/sway/config.d/*

EOF
)
echo $swaycfg > ~/$home/.config/sway/config

#waybar
wbcfg=($cat <<EOF
// =============================================================================
//
// Waybar configuration (https://hg.sr.ht/~begs/dotfiles)
//
// Configuration reference: https://github.com/Alexays/Waybar/wiki/Configuration
//
// =============================================================================

{
    // -------------------------------------------------------------------------
    // Global configuration
    // -------------------------------------------------------------------------

    "layer": "top",
    "position": "top",
    "height": 21,

    "modules-left": [
    	"sway/mode",
        "sway/workspaces",
        "custom/arrow10",
	    "sway/window"
    ],

    //"modules-center": [
    //    "sway/window"
    //],

    "modules-right": [
        "custom/arrow1",
        "pulseaudio",
        "custom/arrow2",
        "network",
        "custom/arrow3",
        "memory",
        "custom/arrow4",
        "cpu",
        "custom/arrow5",
        "temperature",
        "custom/arrow6",
        "custom/layout",
        "custom/arrow7",
        "battery",
        "custom/arrow8",
        "tray",
        "clock#date",
        "custom/arrow9",
        "clock#time"
    ],

    // -------------------------------------------------------------------------
    // Modules
    // -------------------------------------------------------------------------

    "battery": {
        "interval": 1,
        "states": {
            "warning": 30,
            "critical": 15
        },
        "format": " {capacity}%", // Icon: bolt
        "format-discharging": "{icon} {capacity}%",
        "format-icons": [
            "", // Icon: battery-full
            "", // Icon: battery-three-quarters
            "", // Icon: battery-half
            "", // Icon: battery-quarter
            ""  // Icon: battery-empty
        ],
        "tooltip": false
    },

    "clock#time": {
        "interval": 10,
        "format": "{:%H:%M}",
        "tooltip": false
    },

    "clock#date": {
        "interval": 20,
        "format": "{:%e %b %Y}", // Icon: calendar-alt
        //"tooltip-format": "{:%e %B %Y}"
        "tooltip": false
    },

    "cpu": {
        "interval": 5,
        "tooltip": false,
        "format": " {usage}%", // Icon: microchip
        "states": {
          "warning": 70,
          "critical": 90
        }
    },

    "custom/layout": {
      //"exec": "~/.config/waybar/layout.sh",
      "exec": "swaymsg --type get_inputs | grep \"xkb_active_layout_name\" | sed -u '1!d; s/^.*xkb_active_layout_name\": \"//; s/ (US)//; s/\",//' && swaymsg --type subscribe --monitor '[\"input\"]' | sed -u 's/^.*xkb_active_layout_name\": \"//; s/\",.*$//; s/ (US)//'",
      //"interval": 5,
      "format": " {}", // Icon: keyboard
      // Signal sent by Sway key binding (~/.config/sway/key-bindings)
      //"signal": 1, // SIGHUP
      "tooltip": false
    },

    "memory": {
        "interval": 5,
        "format": " {}%", // Icon: memory
        "states": {
            "warning": 70,
            "critical": 90
        }
    },

    "network": {
    	"interval": 5,
    	"format-wifi": "{essid} ({signalStrength}%)",
    	"format-ethernet": "{ifname}",
    	"format-disconnected": "󱘖",
    	"tooltip-format": "{ifname}: {ipaddr}",
    	"on-click": "swaymsg exec \\$term_float iwctl"
    },

    "sway/mode": {
        "format": "<span style=\"italic\"> {}</span>", // Icon: expand-arrows-alt
        "tooltip": false
    },

    "sway/window": {
        "format": "{}",
        "max-length": 30,
	    "tooltip": false
    },

    "sway/workspaces": {
        "all-outputs": false,
        "disable-scroll": false,
        "format": "{name}",
        "format-icons": {
            "1:www": "龜", // Icon: firefox-browser
            "2:mail": "", // Icon: mail
            "3:editor": "", // Icon: code
            "4:terminals": "", // Icon: terminal
            "5:portal": "", // Icon: terminal
            "urgent": "",
            "focused": "",
            "default": ""
        }
    },

    "pulseaudio": {
        "scroll-step": 1,
        "format": "{icon} {volume}%",
        "format-bluetooth": "{icon} {volume}%",
        "format-muted": "",
        "format-icons": {
            "headphones": "",
            "handsfree": "",
            "headset": "",
            "phone": "",
            "portable": "",
            "car": "",
            "default": ["", ""]
        },
        "on-click": "termite --config=/usr/share/sway/themes/matcha-green/termite --name=floating_shell --exec pulsemixer"
    },

    "temperature": {
        "critical-threshold": 90,
        "interval": 5,
        //"format": "{icon} {temperatureC}°C",
	    "format": "{icon} {temperatureC}°",
        "format-icons": [
            "", // Icon: temperature-empty
            "", // Icon: temperature-quarter
            "", // Icon: temperature-half
            "", // Icon: temperature-three-quarters
            ""  // Icon: temperature-full
        ],
        "tooltip": false
    },

    "custom/alsa": {
        "exec": "amixer get Master | sed -nre 's/.*\\[off\\].*/ muted/p; s/.*\\[(.*%)\\].*/ \\1/p'",
        "on-click": "amixer set Master toggle; pkill -x -RTMIN+11 waybar",
        "on-scroll-up": "amixer set Master 1+; pkill -x -RTMIN+11 waybar",
        "on-scroll-down": "amixer set Master 1-; pkill -x -RTMIN+11 waybar",
        "signal": 11,
        "interval": 10,
        "tooltip": false
    },

    "tray": {
        "icon-size": 21
        //"spacing": 10
    },

    "custom/arrow1": {
        "format": "",
        "tooltip": false
    },

    "custom/arrow2": {
        "format": "",
        "tooltip": false
    },

    "custom/arrow3": {
        "format": "",
        "tooltip": false
    },

    "custom/arrow4": {
        "format": "",
        "tooltip": false
    },

    "custom/arrow5": {
        "format": "",
        "tooltip": false
    },

    "custom/arrow6": {
        "format": "",
        "tooltip": false
    },

    "custom/arrow7": {
        "format": "",
        "tooltip": false
    },

    "custom/arrow8": {
        "format": "",
        "tooltip": false
    },

    "custom/arrow9": {
        "format": "",
        "tooltip": false
    },

    "custom/arrow10": {
        "format": "",
        "tooltip": false
    }
}
EOF
)

mkdir -p ~/$home/.config/waybar
echo $wbcfg > ~/$home/.config/waybar/config

wbcss=$(cat << EOF
/* =============================================================================
 *
 * Waybar configuration
 *
 * Configuration reference: https://github.com/Alexays/Waybar/wiki/Configuration
 *
 * =========================================================================== */

/* -----------------------------------------------------------------------------
 * Keyframes
 * -------------------------------------------------------------------------- */

@keyframes blink-warning {
    70% {
        color: @light;
    }

    to {
        color: @light;
        background-color: @warning;
    }
}

@keyframes blink-critical {
    70% {
      color: @light;
    }

    to {
        color: @light;
        background-color: @critical;
    }
}


/* -----------------------------------------------------------------------------
 * Styles
 * -------------------------------------------------------------------------- */

/* COLORS */

/* Nord */
/*@define-color light #eceff4;
@define-color dark #2e3440;
@define-color warning #ebcb8b;
@define-color critical #d08770;
@define-color mode #4c566a;
@define-color workspaces #5e81ac;
@define-color workspacesfocused #81a1c1;
@define-color sound #d8dee9;
@define-color network #4c566a;
@define-color memory #88c0d0;
@define-color cpu #434c5e;
@define-color temp #d8dee9;
@define-color layout #5e81ac;
@define-color battery #88c0d0;
@define-color date #2e3440;
@define-color time #eceff4;*/

/* Gruvbox */
@define-color light #ebdbb2;
@define-color dark #282828;
@define-color warning #fabd2f;
@define-color critical #cc241d;
@define-color mode #a89984;
@define-color workspaces #458588;
@define-color workspacesfocused #83a598;
@define-color sound #d3869b;
@define-color network #b16286;
@define-color memory #8ec07c;
@define-color cpu #98971a;
@define-color temp #b8bb26;
@define-color layout #689d6a;
@define-color battery #fabd2f;
@define-color date #282828;
@define-color time #ebdbb2;

/* Reset all styles */
* {
    border: none;
    border-radius: 0;
    min-height: 0;
    margin: 0;
    padding: 0;
}

/* The whole bar */
#waybar {
    background: transparent;
    color: @light;
    font-family: Terminus, FiraCode, Noto Sans;
    font-size: 10pt;
    font-weight: bold;
}

/* Each module */
#battery,
#clock,
#cpu,
#custom-layout,
#memory,
#mode,
#network,
#pulseaudio,
#temperature,
#custom-alsa,
#tray {
    padding-left: 10px;
    padding-right: 10px;
}

/* Each module that should blink */
#mode,
#memory,
#temperature,
#battery {
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    animation-direction: alternate;
}

/* Each critical module */
#memory.critical,
#cpu.critical,
#temperature.critical,
#battery.critical {
    color: @critical;
}

/* Each critical that should blink */
#mode,
#memory.critical,
#temperature.critical,
#battery.critical.discharging {
    animation-name: blink-critical;
    animation-duration: 2s;
}

/* Each warning */
#network.disconnected,
#memory.warning,
#cpu.warning,
#temperature.warning,
#battery.warning {
    color: @warning;
}

/* Each warning that should blink */
#battery.warning.discharging {
    animation-name: blink-warning;
    animation-duration: 3s;
}

/* And now modules themselves in their respective order */

#mode { /* Shown current Sway mode (resize etc.) */
	color: @light;
	background: @mode;
}

/* Workspaces stuff */
#workspaces button {
	font-weight: bold; /* Somewhy the bar-wide setting is ignored*/
	padding-left: 5px;
	padding-right: 5px;
	color: @dark;
	background: @workspaces;
}

#workspaces button.focused {
    background: @workspacesfocused;
}

/*#workspaces button.urgent {
	border-color: #c9545d;
	color: #c9545d;
}*/

#window {
	margin-right: 40px;
	margin-left: 40px;
}

#custom-alsa {
	background: @sound;
	color: @dark;
}

#network {
    background: @network;
    color: @light;
}

#memory {
    background: @memory;
    color: @dark;
}

#cpu {
    background: @cpu;
    color: @light;
}

#temperature {
    background: @temp;
    color: @dark;
}

#custom-layout {
    background: @layout;
    color: @light;
}

#battery {
    background: @battery;
    color: @dark;
}

#tray {
    background: @date;
}

#clock.date {
    background: @date;
    color: @light;
}

#clock.time {
    background: @time;
    color: @dark;
}

#pulseaudio { /* Unsused but kept for those who needs it */
    background: @sound;
    color: @dark
}

#pulseaudio.muted {
    /* No styles */
}

#custom-arrow1 {
    font-size: 16px;
    color: @sound;
    background: transparent;
}

#custom-arrow2 {
    font-size: 16px;
    color: @network;
    background: @sound;
}

#custom-arrow3 {
    font-size: 16px;
    color: @memory;
    background: @network;
}

#custom-arrow4 {
    font-size: 16px;
    color: @cpu;
    background: @memory;
}

#custom-arrow5 {
    font-size: 16px;
    color: @temp;
    background: @cpu;
}

#custom-arrow6 {
    font-size: 16px;
    color: @layout;
    background: @temp;
}

#custom-arrow7 {
    font-size: 16px;
    color: @battery;
    background: @layout;
}

#custom-arrow8 {
    font-size: 16px;
    color: @date;
    background: @battery;
}

#custom-arrow9 {
    font-size: 16px;
    color: @time;
    background: @date;
}

#custom-arrow10 {
    font-size: 16px;
    color: @workspaces;
    background: transparent;
}
EOF
)

echo $wbcss > ~/$home/.config/waybar/style.css
cp -r ~/.config/dconf ~/$home/.config/

