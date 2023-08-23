#!/usr/bin/env bash

case "$1" in
    --list) cliphist list | fuzzel --dmenu -font -p "Select item to copy:" --lines 10 --width 60 | cliphist decode | wl-copy;;
    --del) cliphist list | fuzzel --dmenu -font -p "Select item to delete:" --lines 10 --width 60 | cliphist delete;;
esac
