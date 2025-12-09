
#!/usr/bin/env bash
set -euo pipefail

INT="eDP-1"
EXT="HDMI-A-1"

notify() {
    notify-send "Display Mode" "$1"
}

is_connected() {
    niri msg outputs | grep -q "$1"
}

is_enabled() {
    niri msg outputs | grep -A3 "$1" | grep -q "Current mode"
}

HAS_INT=false
HAS_EXT=false

if is_connected "$INT"; then HAS_INT=true; fi
if is_connected "$EXT"; then HAS_EXT=true; fi

INT_ON=false
EXT_ON=false

if is_enabled "$INT"; then INT_ON=true; fi
if is_enabled "$EXT"; then EXT_ON=true; fi

# Cycle logic: Laptop → External → Both → Laptop
if $INT_ON && ! $EXT_ON; then
    NEXT="external"
elif ! $INT_ON && $EXT_ON; then
    NEXT="both"
else
    NEXT="laptop"
fi

case "$NEXT" in
    laptop)
        notify "Switching → Laptop Only"
        niri msg output "$EXT" off
        niri msg output "$INT" on
        ;;

    external)
        notify "Switching → External Only"
        niri msg output "$INT" off
        niri msg output "$EXT" on
        ;;

    both)
        notify "Switching → Both Displays"
        niri msg output "$INT" on
        niri msg output "$EXT" on
        # Position external to right of laptop
        #niri msg output "$EXT" position 1920 0
        ;;
esac
