#!/usr/bin/env bash

HASH="$(echo "$@" | shasum | cut -f1 -d" " | cut -c1-7)"
term_float="alacritty --class floating_shell -e"
FLOCK="flock --verbose -n "$HOME/.local/state/${HASH}.lock""
$FLOCK $term_float bluetuith

