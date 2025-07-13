#!/bin/bash

# Based on:
#
# - https://ubuntu-mate.community/t/controlling-raspberry-pi-with-tv-remote-using-hdmi-cec/4250
# - https://forums.raspberrypi.com/viewtopic.php?t=364910#p2189084

function keychar {
    parin1=$1 # first parameter, abc1
    parin2=$2 # second parameter, 0=a, 1=b, 2=c, 3=1, 4=a, ...
    parin2=$((parin2)) # convert to numeric
    parin1len=${#parin1} # length of parin1
    parin2pos=$((parin2 % parin1len)) # position mod
    char=${parin1:parin2pos:1} # char key to simulate
    if [ "$parin2" -gt 0 ]; then # if same key pressed multiple times, delete previous char; write a, delete a write b, delete b write c, ...
        xdotool key 'BackSpace'
    fi
    # special cases for xdotool ( X Keysyms )
    if [ "$char" = ' ' ]; then char='space'; fi
    if [ "$char" = '.' ]; then char='period'; fi
    if [ "$char" = '-' ]; then char='minus'; fi
    xdotool key $char
}

strlastkey=''
intkeychar=0
intmsbetweenkeys=2000 # two presses of a key sooner that this makes it delete previous key and write the next one (a->b->c->1->a->...)
intmousestartspeed=10 # mouse starts moving at this speed (pixels per key press)
intmouseacc=10        # added to the mouse speed for each key press (while holding down key, more key presses are sent from the remote)
intmousespeed=10
lasttimestamp=0

debugMode=0

while getopts "d" opt; do
  case $opt in
    f)
        debugMode=1
        ;;
    \?)
        echo "[ERROR] Unknown option -$OPTARG" >&2
        exit 1
    ;;
  esac
done

while read oneline
do
    #echo '[DEBUG]' $oneline
    if [ "${oneline:28:12}" == 'key pressed:' ]; then
        timestamp=${oneline:10:16}
        let datdiff=timestamp-lasttimestamp

        #if [ $debugMode == 1 ]; then
        #    echo 'Key pressed:' $timestamp $datdiff
        #fi

        if [ $datdiff -gt 5 ]; then # we ignore duplicate key pressed messages (time stamps less than Xms diff)
            strkey=${oneline#*]	key pressed: }
            strkey=${strkey%% (*}
            #echo $strkey

            if [ "$strkey" = "$strlastkey" ] && [ "$datdiff" -lt "$intmsbetweenkeys" ]; then
                ((intkeychar += 1)) # same key pressed for a different char so increment
            else
                intkeychar=0 # different key / too far apart
            fi

            lasttimestamp=$timestamp
            strlastkey=$strkey

            if [ $debugMode == 1 ]; then
                echo 'Process key pressed:' $strkey $timestamp $datdiff
            fi

            # process key presses here
            case "$strkey" in
                #'1')
                #    xdotool key 'BackSpace'
                #    ;;
                #'2')
                #    keychar 'abc2' intkeychar
                #    ;;
                #'3')
                #    keychar 'def3' intkeychar
                #    ;;
                #'4')
                #    keychar 'ghi4' intkeychar
                #    ;;
                #'5')
                #    keychar 'jkl5' intkeychar
                #    ;;
                #'6')
                #    keychar 'mno6' intkeychar
                #    ;;
                #'7')
                #    keychar 'pqrs7' intkeychar
                #    ;;
                #'8')
                #    keychar 'tuv8' intkeychar
                #    ;;
                #'9')
                #    keychar 'wxyz9' intkeychar
                #    ;;
                #'0')
                #    keychar ' 0.-' intkeychar
                #    ;;
                #'previous channel')
                #    xdotool key 'Escape'
                #    ;;
                'F1')
                    #echo 'Pressed F1'
                    #xdotool click --repeat 2 1 # double click left
                    xdotool key 'F5' # reload browser tab
                    ;;
                'F2')
                    #echo 'Pressed F2'
                    xdotool key 'E' # switch between single camera and cameras overview in Synology Motion Center
                    ;;
                'F3')
                    #echo 'Pressed F3'
                    xdotool key 'Left' # arrow key left
                    ;;
                'F4')
                    #echo 'Pressed F4'
                    xdotool key 'Right' # arrow key right
                    ;;
                'channel up')
                    xdotool click 4 # mouse scroll up
                    ;;
                'channel down')
                    xdotool click 5 # mouse scroll down
                    ;;
                #'setup menu')
                #    xdotool click 3 # right mouse button click and move a bit right
                #    xdotool mousemove_relative -- 10 0
                #    ;;
                'up')
                    #echo 'Pressed UP'
                    intpixels=$((-1 * intmousespeed))
                    xdotool mousemove_relative -- 0 $intpixels # move mouse up
                    intmousespeed=$((intmousespeed + intmouseacc)) # speed up
                    ;;
                'down')
                    #echo 'Pressed DOWN'
                    intpixels=$(( 1 * intmousespeed))
                    xdotool mousemove_relative -- 0 $intpixels # move mouse down
                    intmousespeed=$((intmousespeed + intmouseacc)) # speed up
                    ;;
                'left')
                    #echo 'Pressed LEFT'
                    intpixels=$((-1 * intmousespeed))
                    xdotool mousemove_relative -- $intpixels 0 # move mouse left
                    intmousespeed=$((intmousespeed + intmouseacc)) # speed up
                    ;;
                'right')
                    #echo 'Pressed RIGHT'
                    intpixels=$(( 1 * intmousespeed))
                    xdotool mousemove_relative -- $intpixels 0 # move mouse right
                    intmousespeed=$((intmousespeed + intmouseacc)) # speed up
                    ;;
                'select')
                    xdotool click 1 # left mouse button click
                    ;;
                'Fast forward') # starts with a capital `F`
                    #xdotool key 'greater' # ffwd in omxplayer
                    xdotool key 'Ctrl+Tab'
                    ;;
                'rewind')
                    #xdotool key 'less' # rewind in omxplayer
                    xdotool key 'Ctrl+Shift+Tab'
                    ;;
                #'backward')
                #    xdotool key 'i' # last chapter in omxplayer
                #    ;;
                #'forward')
                #    xdotool key 'o' # next chapter in omxplayer
                #    ;;
                'play')
                    #xdotool key 'p' # pause in omxplayer
                    echo 'Pressed PLAY'
                    ;;
                'pause')
                    #xdotool key 'p' # pause in omxplayer
                    echo 'Pressed PAUSE'
                    ;;
                #'stop')
                #    xdotool key 'q' # rewind in omxplayer
                #    ;;
                'exit')
                    xdotool key 'Escape'
                    ;;
                *)
                    echo Unrecognized key pressed: $strkey ; CEC Line: $keyline
                    ;;
            esac
        fi
    fi

    if [ "${oneline:28:13}" == 'key released:' ]; then
        strkey=${oneline#*]	key released: }
        strkey=${strkey%% (*}

        if [ $debugMode == 1 ]; then
            echo 'Process key released:' $strkey
        fi

        # process key releases here
        case "$strkey" in
            'up')
                intmousespeed=$intmousestartspeed # reset mouse speed
                ;;
            'down')
                intmousespeed=$intmousestartspeed # reset mouse speed
                ;;
            'left')
                intmousespeed=$intmousestartspeed # reset mouse speed
                ;;
            'right')
                intmousespeed=$intmousestartspeed # reset mouse speed
                ;;
        esac
    fi
done
