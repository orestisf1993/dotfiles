#!/bin/bash -x
export VISUAL=vim
export TERMINAL=urxvt
export DESKTOP_SESSION=gnome
# export QT_STYLE_OVERRIDE=GTK+  # Tell Qt to use GTK style
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
export GTK_OVERLAY_SCROLLING=0
export STEAM_RUNTIME=0
D="${D:-100}"
export RXVT_SOCKET=/tmp/urxvtd-$D.socket

xephyr_name(){
    echo "Xephyr_$D"
}

xephyr_pid(){
    pgrep -f "$(xephyr_name)"
}

xephyr_kill(){
    kill "$(xephyr_pid)"
}

finish() {
    echo "Trapped CTRL-C: killing i3, xephyr"
    i3-msg exit
    xephyr_kill
    kill "$wall_pid"
    kill "$urxvtd_pid" # Just in case
    exit 0
}

set -m

Xephyr -name "$(xephyr_name)" -terminate -br -ac -noreset -screen 1680x995 :$D &
export DISPLAY=:$D
echo "Ran Xephyr with :display $DISPLAY"
sleep 0.7 # Wait for Xephyr.

userresources=$HOME/.Xresources
sysresources=/etc/X11/xinit/.Xresources

# merge in defaults and keymaps
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

# "$HOME/bin/generate-i3-config.sh"
rm -f "$RXVT_SOCKET"
urxvtd --quiet --fork --opendisplay&
urxvtd_pid=$!
~/bin/rand_wall.sh&
wall_pid=$!

cp ~/.i3/config /tmp/i3.config
trap finish INT
echo "Passing args '$*' to i3"
if [[ -n "$ISSUE_I3" ]]; then
    i3 --moreversion 2>&- || i3 --version
    "$HOME/Documents/programming/i3/build/i3" -c ~/Desktop/default.config --shmlog-size=26214400 "$@"
    i3-dump-log | vipe | bzip2 -c | curl --data-binary @- http://logs.i3wm.org
elif [[ -n "$GDB_I3" ]]; then
    gdb --args "$HOME/Documents/programming/i3/build/i3" -c /tmp/i3.config -V -d all "$@"
else
    "$HOME/Documents/programming/i3/build/i3" -c /tmp/i3.config -V "$@" 2>&1 &
    wait $!
fi
finish