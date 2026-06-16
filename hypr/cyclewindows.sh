#!/bin/sh

# Usage: ./cycle-windows.sh next  OR  ./cycle-windows.sh prev
DIRECTION=$1

# Get active window data
WINDOW=$(hyprctl activewindow -j)
IS_GROUPED=$(echo "$WINDOW" | jq -r '.grouped | length > 0')

if [ "$IS_GROUPED" = "true" ]; then
    # Get all window addresses in the group
    GROUP_ADDRS=$(echo "$WINDOW" | jq -r '.grouped[]')
    CURRENT_ADDR=$(echo "$WINDOW" | jq -r '.address')
    
    # Identify first and last in group
    FIRST_ADDR=$(echo "$GROUP_ADDRS" | head -n 1)
    LAST_ADDR=$(echo "$GROUP_ADDRS" | tail -n 1)

    if [ "$DIRECTION" = "next" ]; then
        if [ "$CURRENT_ADDR" == "$LAST_ADDR" ]; then
            # Use 'mon:.' to stay on the current monitor
            hyprctl dispatch cyclenext mon:.
        fi
        hyprctl dispatch changegroupactive f
    else # Direction is prev
        if [ "$CURRENT_ADDR" == "$FIRST_ADDR" ]; then
            hyprctl dispatch cyclenext prev mon:.
        fi
        hyprctl dispatch changegroupactive b
    fi
else
    # Not grouped, standard monitor-aware cycle
    if [ "$DIRECTION" = "next" ]; then
        hyprctl dispatch cyclenext mon:.
	hyprctl dispatch changegroupactive f
    else
        hyprctl dispatch cyclenext prev mon:.
	hyprctl dispatch changegroupactive b
    fi
fi
