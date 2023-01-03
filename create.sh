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

