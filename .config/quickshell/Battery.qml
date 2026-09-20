import Quickshell
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts

// waybar `battery`. Hidden when no battery is present (desktop).
Pill {
  id: root

  readonly property var dev: UPower.displayDevice
  readonly property bool present: dev && dev.isPresent && dev.isLaptopBattery
  readonly property int percent: present ? Math.round(dev.percentage * 100) : 0
  readonly property bool charging: present
    && (dev.state === UPowerDeviceState.Charging
        || dev.state === UPowerDeviceState.PendingCharge)
  readonly property bool plugged: present
    && dev.state === UPowerDeviceState.FullyCharged

  // "critical": 15 in the states block.
  readonly property bool critical: present && percent <= 15 && !charging

  Layout.rightMargin: present ? Theme.moduleGap : 0

  text: {
    if (!present) return "";
    if (charging) return "⚡ " + percent + "%";
    if (plugged) return "\uf1e6 " + percent + "%";
    // format-icons, each with the trailing space waybar has.
    const icons = ["\uf244 ", "\uf243 ", "\uf242 ", "\uf241 ", "\uf240 "];
    const i = Math.min(4, Math.floor(percent / 20));
    return icons[i] + " " + percent + "%";
  }

  color: critical ? Theme.critical : Theme.backgroundLight
  foreground: critical ? Theme.textColor3 : Theme.textColor2

  // `animation: blink 0.5s linear infinite alternate` on .critical
  SequentialAnimation on opacity {
    running: root.critical
    loops: Animation.Infinite
    NumberAnimation { from: 1.0; to: 0.4; duration: 500 }
    NumberAnimation { from: 0.4; to: 1.0; duration: 500 }
  }

  onClicked: Sh.run("kitty -e btop")
}
