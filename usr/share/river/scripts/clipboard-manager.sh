#!/usr/bin/env bash

case "$1" in
    --list) cliphist list | rofi -dmenu -p "Select item to copy:" -lines 10 -width 35 | cliphist decode | wl-copy;;
    --del) cliphist list | rofi -dmenu -p "Select item to delete:" -lines 10 -width 35 | cliphist delete;;
esac
