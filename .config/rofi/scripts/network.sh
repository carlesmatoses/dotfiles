#!/bin/bash
# Rofi Network Manager Script
# Provides a simple dialog interface for network management

if [ -z "$@" ]; then
    # Show available WiFi networks and options
    echo "🔗 Connect to Network"
    echo "⚙️ Network Settings"
    echo "📡 WiFi Networks"
    echo "🔄 Refresh Networks"
    echo "📊 Connection Info"
    echo "🔧 Advanced Settings"
else
    case "$@" in
        "🔗 Connect to Network")
            # Show available WiFi networks
            nmcli device wifi list | grep -v '^*' | awk '{print $2}' | head -10
            ;;
        "⚙️ Network Settings")
            nm-connection-editor &
            ;;
        "📡 WiFi Networks")
            # Show WiFi networks in a simple format
            nmcli device wifi list --rescan yes | grep -v '^*' | awk '{print "📶 " $2 " (" $6 ")"}'
            ;;
        "🔄 Refresh Networks")
            nmcli device wifi rescan
            notify-send "Network" "WiFi networks refreshed"
            ;;
        "📊 Connection Info")
            # Show current connection info
            CONNECTION=$(nmcli connection show --active | grep -v lo | head -1 | awk '{print $1}')
            IP=$(nmcli connection show --active | grep -v lo | head -1 | awk '{print $4}')
            notify-send "Network Info" "Connected to: $CONNECTION\nIP: $IP"
            ;;
        "🔧 Advanced Settings")
            kitty -e nmtui &
            ;;
        *)
            # Try to connect to selected network
            NETWORK=$(echo "$@" | sed 's/📶 //' | sed 's/ (.*//')
            if [ ! -z "$NETWORK" ]; then
                # Prompt for password if needed
                PASSWORD=$(rofi -dmenu -password -p "Password for $NETWORK:")
                if [ ! -z "$PASSWORD" ]; then
                    nmcli device wifi connect "$NETWORK" password "$PASSWORD"
                    if [ $? -eq 0 ]; then
                        notify-send "Network" "Successfully connected to $NETWORK"
                    else
                        notify-send "Network" "Failed to connect to $NETWORK"
                    fi
                fi
            fi
            ;;
    esac
fi
