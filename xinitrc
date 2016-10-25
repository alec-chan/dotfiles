#!/bin/sh


if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
#compton --backend glx --paint-on-overlay --vsync opengl-swc

exec i3
