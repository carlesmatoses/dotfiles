import Quickshell
import Quickshell.Io
import Quickshell.Networking
import QtQuick
import QtQuick.Layouts

// waybar `network`.
//
// Quickshell's NetworkDevice exposes connectivity but its `address` property
// is the MAC, not the IP, and there is no signal-strength field - so the
// displayed values come from a small nmcli poll. The Networking singleton is
// still used as the change trigger so the poll reacts instead of only ticking.
Pill {
  id: root

  property string kind: ""      // "wifi" | "ethernet" | "" (disconnected)
  property string ipaddr: ""
  property string signal_: ""

  readonly property bool connected: kind !== ""

  // Re-poll whenever NetworkManager reports a change.
  readonly property int connectivity: Networking.connectivity
  onConnectivityChanged: proc.running = true

  Layout.rightMargin: Theme.moduleGap

  text: {
    if (kind === "wifi") return "\uf1eb   " + signal_ + "%";
    if (kind === "ethernet") return "\uf0e8  " + ipaddr;
    return "Not connected";
  }

  // `#network.disconnected { background-color: #f53c3c }`
  color: connected ? Theme.backgroundLight : Theme.critical
  foreground: Theme.textColor2

  Process {
    id: proc
    running: true
    command: ["sh", "-c", `
      line=$(nmcli -t -f DEVICE,TYPE,STATE dev status 2>/dev/null \
             | awk -F: '$3=="connected" && ($2=="wifi"||$2=="ethernet"){print; exit}')
      [ -z "$line" ] && exit 0
      dev=$(printf '%s' "$line" | cut -d: -f1)
      type=$(printf '%s' "$line" | cut -d: -f2)
      ip=$(nmcli -g IP4.ADDRESS dev show "$dev" 2>/dev/null | head -1 | cut -d/ -f1)
      if [ "$type" = wifi ]; then
        sig=$(nmcli -t -f ACTIVE,SIGNAL dev wifi 2>/dev/null \
              | awk -F: '$1=="yes"{print $2; exit}')
        printf 'wifi|%s|%s' "$ip" "$sig"
      else
        printf 'ethernet|%s|' "$ip"
      fi
    `]

    stdout: StdioCollector {
      onStreamFinished: {
        const parts = this.text.trim().split("|");
        if (parts.length < 3 || parts[0] === "") {
          root.kind = "";
          root.ipaddr = "";
          root.signal_ = "";
          return;
        }
        root.kind = parts[0];
        root.ipaddr = parts[1];
        root.signal_ = parts[2];
      }
    }
  }

  Timer {
    interval: 5000
    running: true
    repeat: true
    onTriggered: proc.running = true
  }

  // The rofi Network modi this used to open was mostly notify-send wrappers
  // around nm-connection-editor and nmtui, so both buttons now go straight
  // to the editor.
  onClicked: Sh.run("nm-connection-editor")
  onRightClicked: Sh.run("kitty -e nmtui")
}
