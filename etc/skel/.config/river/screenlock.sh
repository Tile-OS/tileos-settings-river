#!/bin/bash 

lock="~/.config/swaylock/lock.sh"

pkill swayidle
sleep 1s

exec swayidle -w \
	timeout 240 'light -G > /tmp/brightness && light -S 10' resume 'light -S $([ -f /tmp/brightness ] && cat /tmp/brightness || echo 100%)' \
	timeout 300 $lock \
	before-sleep 'playerctl pause' \
	before-sleep $lock \
	lock $lock & disown
