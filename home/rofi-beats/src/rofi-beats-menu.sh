#!/usr/bin/env bash

# add more args here according to preference
ARGS="--volume=60"

notification(){
# change the icon to whatever you want. Make sure your notification server 
# supports it and already configured.

# Now it will receive argument so the user can rename the radio title
# to whatever they want

	notify-send "Playing now: " "$@" --icon=media-tape
}

menu(){
	printf "1. Lofi Naruto\n"
	printf "2. Lofi Girl\n"
	printf "3. Lofi Animal Crossing\n"
	printf "4. Lofi Zelda\n"
	printf "5. Lofi Ghibli\n"
}

main() {
	choice=$(menu | rofi -dmenu | cut -d. -f1)

	case $choice in
		1)
			notification "Lofi Naruto ☕️🎶";
            URL="https://youtu.be/dd-bYJk8CtM"
			break
			;;
		2)
			notification "Lofi Gril ☕️🎶";
            URL="https://youtu.be/jfKfPfyJRdk"
			break
			;;
		3)
			notification "Lofi Animal Crossing ☕️🎶";
            URL="https://youtu.be/MlvPoNMa8ug"
			break
			;;
		4)
			notification "Lofi Zelda ☕️🎶";
            URL="https://youtu.be/kFDJ-zskFhk"
			break
			;;
		5)
			notification "Lofi Ghibli ☕️🎶";
            URL="https://youtu.be/9gqDH6n3H6I"
			break
			;;
	esac
    # run mpv with args and selected url
    # added title arg to make sure the pkill command kills only this instance of mpv

	if [[ "${URL}x" != "x" ]]; then
		while ${ROFI_BEATS_IS_RUN}; do
			mpv $ARGS --title="radio-mpv" $URL --no-video
		done
	fi
}

pkill -f radio-mpv && main || main
