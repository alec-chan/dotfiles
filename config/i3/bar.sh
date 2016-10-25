#!/bin/bash
HIGHLIGHT="#E4B566"
clock() {
	TIME=$(date "+%H:%M")
	DATE=$(date "+%a %D")
	echo -n "%{F$HIGHLIGHT}$(printf '%b' "")%{F-} $TIME %{F$HIGHLIGHT}$(printf '%b' "")%{F-} $DATE"
}
volume() {
	VOL=$(amixer get Master | grep % | sed -n 1p | awk -F '[' '{print $2}' | awk -F ']' '{print $1}')
	if [ $VOL = '0%' ]; then
		echo -n "%{F$HIGHLIGHT}$(printf '%b' "")%{F-} Mute"
	else
		echo -n "%{F$HIGHLIGHT}$(printf '%b' "")%{F-} $VOL"
	fi
}
wifi() {
    echo -e "%{F$HIGHLIGHT}  %{F-}$(iw wlp3s0 link | grep 'SSID' | cut -c 8-)"
}
mail() {
	# grabs new email # from offlineimap
		echo -e "%{F$HIGHLIGHT}  %{F-}$(ls /home/alec/Mail/INBOX/new | wc -l)"
}
music() {
	SONG=$(mpc current)
	if [ -n $SONG ]; then
		echo -n ""
	else
		echo -n " %{F$HIGHLIGHT}$(printf '%b' "")%{F-} $SONG "
	fi
}
#Copied from /u/Dylan112
workspace() {
	workspacenext="A4:i3-msg workspace next_on_output:"
        workspaceprevious="A5:i3-msg workspace prev_on_output:"
        wslist=$(\
                wmctrl -d \
                | awk '/ / {print $2 $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20}' ORS=''\
                | sed -e 's/\s*  //g' \
                -e 's/\*[ 0-9A-Za-z]*[^ -~]*/  &  /g' \
                -e 's/\-[ 0-9A-Za-z]*[^ -~]*/%{F#3b3b4b}%{A:i3-msg workspace &:}  &  %{A}%{F#A0A0A0}/g' \
                -e 's/\*//g' \
                -e 's/ -/ /g' \
                )
        #echo -n "%{$workspacenext}%{$workspaceprevious}$wslist%{A}%{A}"
	#echo -n "%{A:i3-msg workspace &:}"
}
windowtitle(){
	# Grabs focused window's title
	# The echo "" at the end displays when no windows are focused.
	TITLE=$(xdotool getactivewindow getwindowname 2>/dev/null | sed -n 1p || echo "")
	TITLECUT=$(xdotool getactivewindow getwindowname 2>/dev/null | sed -n 1p | sed 's/\///g;s/-//g;s/ /\\/g' | cut -c 1-6 || echo "")

	if [ $TITLECUT = "glenn@" ]; then
		echo "$(printf '%b' "\ue1d9") $(echo "$TITLE" | cut -c 15-50)"
	else
		echo "$TITLE" | cut -c 1-50
	fi
}
bat() {
    status=$(cat /sys/class/power_supply/BAT0/status)
    capacity=$(cat /sys/class/power_supply/BAT0/capacity)

    if [ "$status" == "Charging" ]; then
        echo -e "%{F$HIGHLIGHT}  %{F-}$capacity%"
    elif (($capacity == 100)); then
        echo -e "%{F$HIGHLIGHT}  %{F-}$capacity%"
    elif (($capacity > 82)); then
        echo -e "%{F$HIGHLIGHT}  %{F-}$capacity%"
    elif (($capacity > 62)); then
        echo -e "%{F$HIGHLIGHT}  %{F-}$capacity%"
    elif (($capacity > 32)); then
        echo -e "%{F$HIGHLIGHT}  %{F-}$capacity%"
    elif (($capacity > 12)); then
        echo -e "%{F$HIGHLIGHT}  %{F-}$capacity%"
    else
        echo -e "%{F$HIGHLIGHT}  %{F-}$capacity%"
    fi
}
while true; do
	echo "%{B#c0303048} $(clock) $(volume) $(mail) $(bat) $(wifi) %{B-}%{c} $(workspace) %{r}%{B-} %{B#5d6383}$(music)%{B#c0303048} $(windowtitle) %{B-}"
	sleep 2;
done |
#old one was '-g 1280x20+45'
lemonbar -p -d -B#c0262626 -F#A0A0A0 -g 2465x40+45+0\
 -f "GohuFont-10"\
 -f "FontAwesome-10"\
 | bash
