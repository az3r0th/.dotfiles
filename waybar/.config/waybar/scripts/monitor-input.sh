#!/bin/bash

# Monitor Mapping:
# Display 1 (Samsung LS27B61x): MacBook=0x0f (DP), PC=0x11 (HDMI-1)
# Display 2 (BenQ EX2710S): MacBook=0x11 (HDMI-1), PC=0x0f (DP)

set_macbook() {
	notify-send "Monitor" "Switching to MacBook..." -i computer -t 1500
	ddcutil --display 1 setvcp 60 0x12 --noverify >/dev/null 2>&1 &
	ddcutil --display 2 setvcp 60 0x12 --noverify >/dev/null 2>&1 &
	wait
}

set_pc() {
	notify-send "Monitor" "Switching to PC..." -i computer -t 1500
	ddcutil --display 1 setvcp 60 0x11 --noverify >/dev/null 2>&1 &
	ddcutil --display 2 setvcp 60 0x0f --noverify >/dev/null 2>&1 &
	wait
}

get_current_value() {
	# Extract the value (x11 or 0x11) regardless of whether 'SNC' is present
	# We look for the last field that starts with 'x' or '0x'
	ddcutil getvcp 60 --brief --display 1 2>/dev/null | awk '{print $NF}' | sed 's/^0x//; s/^x//'
}

get_status() {
	CURRENT=$(get_current_value)
	if [[ "$CURRENT" == "12" ]]; then
		echo '{"text": "󰀵 MacBook"}'
	elif [[ "$CURRENT" == "11" ]]; then
		echo '{"text": "󰪫 PC"}'
	else
		echo '{"text": "󰂚 Monitor"}'
	fi
}

toggle() {
	CURRENT=$(get_current_value)
	if [[ "$CURRENT" == "12" ]]; then
		set_pc
	else
		set_macbook
	fi
}

case "$1" in
macbook) set_macbook ;;
pc) set_pc ;;
toggle) toggle ;;
*) get_status ;;
esac
